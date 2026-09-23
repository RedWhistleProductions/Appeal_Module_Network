#include <iostream>

extern "C" void Debug(bool Enable)
{
	std::cout << "Debug " << Enable << std::endl;
}

extern "C" void Set_Paths(std::string Resources)
{
	std::cout << "Set_Paths(" << Resources << ")" << std::endl;
}

extern "C" void Configure(std::string Type, std::string Host, int Port)
{
	std::cout << "Configure " << Type << " " << Host << " " << Port << std::endl;
}

extern "C" void Server()
{
	std::cout << "Server" << std::endl;
}

extern "C" void Stop_Server()
{
	std::cout << "Stop_Server" << std::endl;
}

extern "C" void Connect(std::string Type)
{
	std::cout << "Connect " << Type << std::endl;
}

extern "C" void Disconnect(std::string Type)
{
	std::cout << "Disconnect " << Type << std::endl;
}

extern "C" void Send(std::string Type, std::string Message)
{
	std::cout << "Send " << Type << ", " << Message << std::endl;
}

extern "C" void Receive(std::string Type)
{
	std::cout << "Receive " << Type << std::endl;
}

extern "C" void Get_IP(std::string Domain)
{
	std::cout << "Get_IP " << Domain << std::endl;
}

extern "C" void Run(std::string Script)
{
	std::cout << "Run " << Script << std::endl;
}

extern "C" void Download(std::string Remote, std::string Local)
{
	std::cout << "Download " << Remote << ", " << Local  << std::endl;
}
