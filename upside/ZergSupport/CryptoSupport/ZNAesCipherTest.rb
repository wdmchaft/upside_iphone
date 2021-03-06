#!/usr/bin/env ruby
#
#  ZNAesCipherTest.rb
#  ZergSupport
#
#  Created by Victor Costan on 4/27/09.
#  Copyright Zergling.Net. Licensed under the MIT license.
#

# Produces golden values for AES cipher test.

require 'digest'
require 'openssl'

key = [0xE8, 0xE9, 0xEA, 0xEB, 0xED, 0xEE, 0xEF, 0xF0, 0xF2,
       0xF3, 0xF4, 0xF5, 0xF7, 0xF8, 0xF9, 0xFA].pack('C*')
iv = [0xeb, 0x16, 0xba, 0xbb, 0x43, 0x13, 0xa8, 0xd1, 0x60,
      0x97, 0xc4, 0x70, 0x1c, 0x20, 0xb5, 0x68].pack('C*')
plain = [0x01, 0x4B, 0xAF, 0x22, 0x78, 0xA6, 0x9D, 0x33, 0x1D,
         0x51, 0x80, 0x10, 0x36, 0x43, 0xE9, 0x9A].pack('C*')

# ECB test.
cipher = OpenSSL::Cipher::Cipher.new 'aes-128-ecb'
cipher.encrypt
cipher.key = key
golden = cipher.update plain
print "ECB: #{golden.unpack('C*').map { |c| "%02x" % c } }\n"

# CBC test.
cipher = OpenSSL::Cipher::Cipher.new 'aes-128-cbc'
cipher.encrypt
cipher.key = key
cipher.iv = iv
golden = cipher.update plain
print "CBC: #{golden.unpack('C*').map { |c| "%02x" % c } }\n"

# Padding test.
cipher = OpenSSL::Cipher::Cipher.new 'aes-128-ecb'
cipher.encrypt
cipher.key = key
golden = cipher.update plain[0, 15] + "\0"
print "ECB padding: #{golden.unpack('C*').map { |c| "%02x" % c } }\n"
