#include "Plugin.h"
#include "Data_Source.h"

Plugin Module;
bool Module_Debug = false;

void (*Debug)(bool Enable);
void (*Set_Paths)(std::string Resources);
void (*Configure)(std::string Type, std::string Host, int Port);
void (*Server)();
void (*Stop_Server)();
void (*Connect)(std::string Type);
void (*Disconnect)(std::string Type);
void (*Send)(std::string Type, std::string Message);
void (*Receive)(std::string Type);
void (*Get_IP)(std::string Domain);
void (*Run)(std::string Script);
void (*Download)(std::string Remote, std::string Local);

template<typename T>
void Assign(std::string Name, T &Function)
{
    Module.Assign(Name, Function);
}

extern "C" void Init(std::string Name)
{
    Module.Load(Name);
    Assign("Debug", Debug);
    Assign("Set_Paths", Set_Paths);
    Assign("Configure", Configure);
    Assign("Server", Server);
    Assign("Stop_Server", Stop_Server);
    Assign("Connect", Connect);
    Assign("Disconnect", Disconnect);
    Assign("Send", Send);
    Assign("Receive", Receive);
    Assign("Get_IP", Get_IP);
    Assign("Run", Run);
    Assign("Download", Download);
}

extern "C" void Interpreter(Data_Source *Data)
{
    std::string Command;
    *Data >> Command;

    if(Command == "Init")
    {
        std::string Name;
        *Data >> Name;
        Init(Name);
    }
    else if(Command == "Debug")
    {
        std::string Value;
        *Data >> Value;
        if(Value == "1" || Value == "On" || Value == "on" || Value == "True" || Value == "true")
        {
            Module_Debug = true;
        }
        else if(Value == "0" || Value == "Off" || Value == "off" || Value == "False" || Value == "false")
        {
            Module_Debug = false;
        }
        if(Debug != nullptr) Debug(Module_Debug);
    }
    else if(Command == "Set_Paths")
    {
        std::string Resources;
        *Data >> Resources;
        if(Set_Paths != nullptr) Set_Paths(Resources);
    }
    else if(Command == "Configure")
    {
        std::string Type, Host;
        int Port;
        *Data >> Type;
        *Data >> Host;
        *Data >> Port;
        if(Configure != nullptr) Configure(Type, Host, Port);
    }
    else if(Command == "Server")
    {
        if(Server != nullptr) Server();
    }
    else if(Command == "Stop_Server")
    {
        if(Stop_Server != nullptr) Stop_Server();
    }
    else if(Command == "Connect")
    {
        std::string Type;
        *Data >> Type;
        if(Connect != nullptr) Connect(Type);
    }
    else if(Command == "Disconnect")
    {
        std::string Type;
        *Data >> Type;
        if(Disconnect != nullptr) Disconnect(Type);
    }
    else if(Command == "Send")
    {
        std::string Type, Message;
        *Data >> Type;
        *Data >> Message;
        if(Send != nullptr) Send(Type, Message);
    }
    else if(Command == "Receive")
    {
        std::string Type;
        *Data >> Type;
        if(Receive != nullptr) Receive(Type);
    }
    else if(Command == "Get_IP")
    {
        std::string Domain;
        *Data >> Domain;
        if(Get_IP != nullptr) Get_IP(Domain);
    }
    else if(Command == "Run")
    {
        std::string Script;
        *Data >> Script;
        if(Run != nullptr) Run(Script);
    }
    else if(Command == "Download")
    {
        std::string Remote, Local;
        *Data >> Remote;
        *Data >> Local;
        if(Download != nullptr) Download(Remote, Local);
    }
    else
    {
        if(Module_Debug) std::cout << "\tError: " << Command << " not found in Network Dictionary" << std::endl;
    }
}
