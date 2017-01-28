describe Fastlane::Actions::InstallAndroidSDKSAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The install_android plugin is working!")
      
      Fastlane::Actions::InstallAndroidSDKSAction.run({})
    end
  end
end
