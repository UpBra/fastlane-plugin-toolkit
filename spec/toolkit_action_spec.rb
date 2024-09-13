describe Fastlane::Helper::Toolkit do

	describe 'test message' do
		it 'prints a message' do
			expect(Fastlane::UI).to receive(:message).with("test message")

			Fastlane::Helper::Toolkit.test_message
		end
	end
end
