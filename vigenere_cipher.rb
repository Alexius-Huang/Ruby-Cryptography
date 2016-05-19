module Cipher
	class Vigenere
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
end