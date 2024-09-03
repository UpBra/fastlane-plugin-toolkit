describe Fastlane::Actions::ToolkitAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The toolkit plugin is working!")

      Fastlane::Actions::ToolkitAction.run(nil)
    end
  end
end
