Facter.add('ubuntu_user') do
	setcode do
		Facter::Core::Execution.exec('cat /etc/passwd | grep "1000" | cut -d ":" -f 1')
	end
end
