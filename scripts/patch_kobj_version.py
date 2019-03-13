#!/usr/bin/env python

from __future__ import print_function

import re
import struct
import sys

from collections import namedtuple


def read_string(bin, offset=0):
  vals = list()

  for k in xrange(offset, len(bin)):
    if bin[k] != '\x00':
      vals.append(bin[k])
    else:
      break

  return ''.join(vals)


def read_file(filename):
  with open(filename, 'r') as fp:
    return fp.read()

  return None


class _IntObj(object):
  def __repr__(self):
    ret = '<_IntObj'
    for key, value in self.__dict__.items():
      ret += ' %s=%s' % (key, str(value))
    ret += '>'

    return ret


def dump_struct(bin, structs, offset=0, size=0, little=True):
  names = list()
  desc = '<' if little else '>'

  for name, flag in structs:
    names.append(name)
    desc += flag

  values = struct.unpack(desc, bin[offset:offset + size])

  ret = _IntObj()
  for k, name in enumerate(names):
    setattr(ret, name, values[k])

  return ret


class Elf(object):
  def __init__(self, filename):

      image = read_file(filename)
      self.head = self._head(image[:52])
      if self.is_valid():
        self.sections = self._section(self.head, image)

  def is_valid(self):
    return self.head.ident.magic == '\x7fELF'

  def _head(self, bin):
    ident = dump_struct(
      bin,
      (
        ('magic', '4s'),
        ('clazz', 'B'),
        ('data', 'B'),
        ('version', 'B'),
        ('os_abi', 'B'),
        ('abi_version', 'B')
      ),
      size=9
    )

    if ident.clazz == 1:
      obj = dump_struct(
        bin,
        (
          ('e_type', 'H'),
          ('e_machine', 'H'),
          ('e_version', 'I'),
          ('e_entry', 'I'),
          ('e_phoff', 'I'),
          ('e_shoff', 'I'),
          ('e_flags', 'I'),
          ('e_ehsize', 'H'),
          ('e_phentsize', 'H'),
          ('e_phnum', 'H'),
          ('e_shentsize', 'H'),
          ('e_shnum', 'H'),
          ('e_shstrndx', 'H')
        ),
        offset=16,
        size=36,
        little=ident.data == 1
      )

    obj.ident = ident
    return obj

  def _section(self, head, bin):
    sections = list()

    for id in xrange(head.e_ehsize):
      if head.ident.clazz == 1:
        sections.append(
          dump_struct(
            bin[head.e_shoff + id * 40:head.e_shoff + id * 40 + 40],
            (
              ('sh_name', 'I'),
              ('sh_type', 'I'),
              ('sh_flags', 'I'),
              ('sh_addr', 'I'),
              ('sh_offset', 'I'),
              ('sh_size', 'I'),
              ('sh_link', 'I'),
              ('sh_info', 'I'),
              ('sh_addralign', 'I'),
              ('sh_entsize', 'I')
            ),
            size=40
          )
        )

    # update section name
    sect_ndx = sections[head.e_shstrndx]
    strtab = bin[sect_ndx.sh_offset:sect_ndx.sh_offset + sect_ndx.sh_size]

    for section in sections:
      section.name = read_string(strtab, section.sh_name)

    return sections


KoVerions = namedtuple("KoVersions", "order,maps")


class KSymbolsVersion(object):
  def __init__(self, bin, symbolver, little=True):
    self.little = little
    self.origin = self.load_from_bin(bin)
    self.refers = KSymbolsVersion.load_symvers(symbolver)

  def load_from_bin(self, bin):
    k, size = 0, len(bin)

    ret, order = dict(), list()
    desc = '<I' if self.little else '>I'
    while k < size:
      ver = struct.unpack(desc, bin[k:k+4])
      func = read_string(bin[k+4:k+64])
      if func:
        order.append(func)
        ret[func] = ver[0]

      k += 64

    return KoVerions(order, ret)

  def generate_bin(self, verbose=False):
    order, maps = self.origin

    for func in maps:
      if func in self.refers:
        if verbose and maps[func] != self.refers[func]:
            print('Update %s' % func)

        maps[func] = self.refers[func]

    ret = ''
    desc = '<I60s' if self.little else '>I60s'
    for func in order:
      block = struct.pack(desc, maps[func], func)
      ret += block

    return ret

  @staticmethod
  def load_symvers(filename):
    ret = dict()

    with open(filename, 'r') as fp:
      for li in fp.readlines():
        lins = re.split(r'\s+', li)
        if len(lins) > 2:
          ret[lins[1]] = int(lins[0], 16)

    return ret


if __name__ == '__main__':
  kofile = None
  symver = None
  verbose = False

  for argv in sys.argv[1:]:
    if argv == '-v':
      verbose = True
    elif not kofile:
      kofile = argv
    elif not symver:
      symver = argv

  if verbose:
    print('Update %s' % kofile)

  elf = Elf(kofile)
  if elf.is_valid():
    sectv = None
    for sect in elf.sections:
      if sect.name == '__versions':
        sectv = sect
        break

    if sectv:
      image = read_file(kofile)
      kversion = KSymbolsVersion(
        image[sectv.sh_offset:sectv.sh_offset + sectv.sh_size],
        symver, elf.head.ident.data)

      blversion = kversion.generate_bin(verbose)
      if len(blversion) != sectv.sh_size:
          print('Warning: section size changed (%d -> %d)' % (
              sectv.sh_size, len(blversion)))

      with open(kofile, "r+") as fp:
        fp.seek(sectv.sh_offset)
        fp.write(blversion)
