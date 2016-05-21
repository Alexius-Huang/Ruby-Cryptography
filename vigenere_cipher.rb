module Cipher
	class Vigenere
		# attr_accessor :key

		def initialize(key)
			@key = key.upcase
			raise_error_input @key
		end

		def encrypt(message)
			message = message.upcase
			raise_error_input	message		
			shift_key = obtain_shifted_key @key
			encrypted_message = ""
			message.length.times do |index|
				shift = message[index].ord + shift_key[index % @key.length]
				shift -= 26 if shift > "Z".ord
				encrypted_message << shift.chr
			end
			return encrypted_message
		end

		def decrypt(message)
			message = message.upcase
			raise_error_input message
			shift_key = obtain_shifted_key @key
			decrypted_message = ""
			message.length.times do |index|
				shift = message[index].ord - shift_key[index % @key.length]
				shift += 26 if shift < "A".ord
				decrypted_message << shift.chr
			end
			return decrypted_message				
		end

		def random_key(length)
			raise "Should specify length of the key over 0." if length.nil? || length.zero?
			@key = ""
			length.times { @key << rand(('A'.ord)..('Z'.ord)).chr }
		end

		private

		def raise_error_input(input)
				raise "Should not contain any characters other than English letters." if /^[A-Z]+$/.match(input).nil?
			end

			def obtain_shifted_key(key)
				shift = []
			@key.each_char { |char| shift << (char.ord - "A".ord) }
			return shift
		end
	end

	module SymmetricEncryption
		class MD5
			def self.encrypt(message)
				# Convert message into hexadecimal message
				hexadecimal = ""
				message.each_char { |char| hexadecimal << char.ord.to_s(16) }
				hexadecimal = hexadecimal.upcase
				length_of_hexadecimal = hexadecimal.length * 4 # Unit: bit(s)
				decimal = hexadecimal.hex

				# Fill in 1 and 0s until the lenth MOD 448 bit == 0
				hexadecimal << "80"
				hexadecimal << "0" until hexadecimal.length % 112 == 0 # 448 bits = 112 bytes
			
				# Fill in the length of the message (in bits)
				md5 = Cipher::SymmetricEncryption::MD5
				message_length_little_endian = md5.little_endian(length_of_hexadecimal.to_s(16))
				message_length_little_endian << "0" until message_length_little_endian.length % 16 == 0
				hexadecimal << message_length_little_endian.upcase

				# Initialize 4 Registers
				A_REGISTER = "01234567"
				B_REGISTER = "89ABCDEF"
				C_REGISTER = "FEDCBA98"
				D_REGISTER = "76543210"

				# 

				# DEBUG
				# puts "hexadecimal : " + hexadecimal.to_s
				# puts "length_of_hexadecimal : " + length_of_hexadecimal.to_s
				# puts "decimal : " + decimal.to_s
				# puts "message_length_little_endian : " + message_length_little_endian.to_s

			end

			private

			def self.little_endian(input)
				input = "0" << input if input.length.odd?
				partition = [""]
				input.reverse.each_char do |char|
					if partition.last.length.even? || partition.last.empty?
						partition << char
					else
						(partition.last << char).reverse!
					end
				end
				return partition.join
			end
		end
	end
end











































