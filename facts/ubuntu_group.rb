Facter.add('ubuntu_group') do
	setcode do
		Facter::Core::Execution.exec('cat /etc/group | grep "1000" | cut -d ":" -f 1')
	end
end
