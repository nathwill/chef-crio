control 'installs the packages' do
  describe package('cri-o') do
    it { should be_installed }
  end

  describe package('podman') do
    it { should be_installed }
  end
end
