require 'base64'
require 'digest/sha2'
require 'openssl'

class Decryptor

  def initialize(encrypted_data, key, iv, options = {})
    @encrypted_data = encrypted_data
    @key = key
    @iv = iv
    default_options = {
        :cipher => 'aes-256-cbc'
    }
    @options = default_options.merge(options)
  end

  def encrypted_bytes
    Base64.decode64(@encrypted_data)
  end

  def iv
    Base64.decode64(@iv)
  end

  def key
    Digest::SHA256.digest(@key)
  end

  def openssl_decryptor
    @openssl_decryptor ||= begin
      d = OpenSSL::Cipher::Cipher.new(@options[:cipher])
      d.decrypt
      d.key = key
      d.iv = iv
      d
    end
  end

  def decrypted_data
    @decrypted_data ||= begin
      plaintext = openssl_decryptor.update(encrypted_bytes)
      plaintext << openssl_decryptor.final
    rescue OpenSSL::Cipher::CipherError => e
      raise "Error decrypting data: '#{e.message}'. Most likely the provided key is incorrect"
    end
  end


end