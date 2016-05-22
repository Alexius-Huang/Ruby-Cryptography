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

	module Hash
		class MD5
			def self.encrypt(message)
				md5 = Cipher::Hash::MD5

				# Convert message into hexadecimal message
				hexadecimal = ""
				message.each_char { |char| hexadecimal << char.ord.to_s(16) }
				hexadecimal = hexadecimal.upcase
				length_of_hexadecimal = hexadecimal.length * 4 # Unit: bit(s)
				decimal = hexadecimal.hex

				# Fill in 1 and 0s until the lenth MOD 448 bit == 0
				hexadecimal << "80"
				hexadecimal << "0" until (hexadecimal.length % 128 + 1) % (112 + 1) == 0 # 448 bits = 112 bytes
				puts "Check hexadecimal fill in 1 and 0's : \n" << hexadecimal

				# Fill in the length of the message (in bits)
				message_length_little_endian = md5.little_endian(length_of_hexadecimal.to_s(16))
				message_length_little_endian << "0" until message_length_little_endian.length % 16 == 0
				hexadecimal << message_length_little_endian.upcase

				# Initialize 4 Registers
				a_REGISTER = md5.little_endian "01234567"
				b_REGISTER = md5.little_endian "89ABCDEF"
				c_REGISTER = md5.little_endian "FEDCBA98"
				d_REGISTER = md5.little_endian "76543210"
				#	puts a_REGISTER << b_REGISTER << c_REGISTER << d_REGISTER # DEBUG

				# Partition hexedecimal message
				partitioned_512bits = md5.partition_by_bytes(hexadecimal, 128)
				puts "Partitioned 512 bits parts : " << partitioned_512bits.length.to_s # DEBUG
				puts "Partitioned 512 bits : \n" <<  partitioned_512bits.join("\n") # DEBUG
				m = []
				partitioned_512bits.each.with_index do |part, index|
					m << partition_by_bytes(part, 8)
				end
				m.each.with_index { |item, index| puts "Check #{index.next} : \n" << item.join("\ne") } # DEBUG




				# DEBUG
				puts "hexadecimal : " + hexadecimal.to_s
				# puts "length_of_hexadecimal : " + length_of_hexadecimal.to_s
				puts "decimal : " + decimal.to_s
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

			def self.partition_by_bytes(input, bytes)
				result = [""]
				input.each_char do |char|
					if result.last.length < bytes
						result.last << char
					else
						result << char
					end
				end
				return result
			end

			def self.left_round_shifted(input, s)
				s.times { input = input[1..-1] << input[0] }
			end

			def logic_not(input)
				input = ("FFFFFFFF".hex - input.hex).to_s(16).upcase
			end

			# Non Linear Functions
			def self.func_F(x, y, z)
				(x & y) | (logic_not(x) & z)
			end

			def self.func_G(x, y, z)
				(x & z) | (y & logic_not(z))
			end

			def self.func_H(x, y, z)
				x ^ y ^ z
			end

			def self.func_I(x, y, z)
				y ^ (x | logic_not(z))
			end

			def self.func_FF(w, x, y, z, message_part, shift_times, ti)
				md5 = Cipher::Hash::MD5
				return w = x + md5.left_round_shifted((w + md5.func_F(x, y, z) + message_part + ti), shift_times)
			end

			def self.func_GG(w, x, y, z, message_part, shift_times, ti)
				md5 = Cipher::Hash::MD5
				return w = x + md5.left_round_shifted((w + md5.func_G(x, y, z) + message_part + ti), shift_times)
			end

			def self.func_HH(w, x, y, z, message_part, shift_times, ti)
				md5 = Cipher::Hash::MD5
				return w = x + md5.left_round_shifted((w + md5.func_H(x, y, z) + message_part + ti), shift_times)
			end

			def self.func_II(w, x, y, z, message_part, shift_times, ti)
 				md5 = Cipher::Hash::MD5
 				return w = x + md5.left_round_shifted((w + md5.func_I(x, y, z) + message_part + ti), shift_times)
 			end
		end
	end
end











































