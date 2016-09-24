#include <iostream>
#define _WIN32_WINNT 0x0500
#include <windows.h>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <winver.h>
#include <tchar.h>
#include <thread>
using namespace std;

HWND CurrentConosoleWindow = GetConsoleWindow();

void ClearConsoleToColors(int ForgC, int BackC)
{
 WORD wColor = ((BackC & 0x0F) << 4) + (ForgC & 0x0F);
               //Get the handle to the current output buffer...
 HANDLE hStdOut = GetStdHandle(STD_OUTPUT_HANDLE);
                     //This is used to reset the carat/cursor to the top left.
 COORD coord = {0, 0};
                  //A return value... indicating how many chars were written
                    //   not used but we need to capture this since it will be
                      //   written anyway (passing NULL causes an access violation).
 DWORD count;

                               //This is a structure containing all of the console info
                      // it is used here to find the size of the console.
 CONSOLE_SCREEN_BUFFER_INFO csbi;
                 //Here we will set the current color
 SetConsoleTextAttribute(hStdOut, wColor);
 if(GetConsoleScreenBufferInfo(hStdOut, &csbi))
 {
                          //This fills the buffer with a given character (in this case 32=space).
      FillConsoleOutputCharacter(hStdOut, (TCHAR) 32, csbi.dwSize.X * csbi.dwSize.Y, coord, &count);

      FillConsoleOutputAttribute(hStdOut, csbi.wAttributes, csbi.dwSize.X * csbi.dwSize.Y, coord, &count );
                          //This will set our cursor position for the next print statement.
      SetConsoleCursorPosition(hStdOut, coord);
 }
 return;
}




//void SetColor(int ForgC)
 //{
 //WORD wColor;

 // HANDLE hStdOut = GetStdHandle(STD_OUTPUT_HANDLE);
 // CONSOLE_SCREEN_BUFFER_INFO csbi;

                       //We use csbi for the wAttributes word.
 //if(GetConsoleScreenBufferInfo(hStdOut, &csbi))
 //{
                 //Mask out all but the background attribute, and add in the forgournd color
   //   wColor = (csbi.wAttributes & 0xF0) + (ForgC & 0x0F);
   //   SetConsoleTextAttribute(hStdOut, wColor);
 //}
// return;
//}




int launch(){
SHELLEXECUTEINFO StartRails80;
StartRails80.cbSize = sizeof(SHELLEXECUTEINFO);
StartRails80.fMask = (SEE_MASK_NOCLOSEPROCESS | SEE_MASK_FLAG_NO_UI | SEE_MASK_NO_CONSOLE);
StartRails80.hwnd = NULL;
StartRails80.lpVerb = NULL;
//StartRails80.lpFile = "cmd.exe";
//StartRails80.lpParameters = "/c \"rails s -p 80\"";
StartRails80.lpFile = "C:\\Ruby23-x64\\bin\\ruby.exe";
StartRails80.lpParameters = "\"C:\\Ruby23-x64\\bin\\rails\" s -p 80 -b 0.0.0.0";
StartRails80.lpDirectory = "C:\\PoGoBag";
StartRails80.nShow = SW_SHOW;
StartRails80.hInstApp = NULL;
ShellExecuteEx(&StartRails80);
WaitForSingleObject(StartRails80.hProcess,INFINITE);
return 0;
}

int OpenLocalhost()
{
    Sleep(4500);
    ShellExecute(NULL, "open", "http://localhost", NULL, NULL, SW_SHOWNORMAL);
    return 0;
}
//"C:\Ruby23-x64\bin\ruby.exe"  "C:\Ruby23-x64\bin\rails" s -p 80




int GetServiceStatus( const char* name )
{
    SC_HANDLE theService, scm;
    SERVICE_STATUS m_SERVICE_STATUS;
    SERVICE_STATUS_PROCESS ssStatus;
    DWORD dwBytesNeeded;


    scm = OpenSCManager( nullptr, nullptr, SC_MANAGER_ENUMERATE_SERVICE );
    if( !scm ) {
        return 0;
    }

    theService = OpenService( scm, name, SERVICE_QUERY_STATUS );
    if( !theService ) {
        CloseServiceHandle( scm );
        return 0;
    }

    auto result = QueryServiceStatusEx( theService, SC_STATUS_PROCESS_INFO,
        reinterpret_cast<LPBYTE>( &ssStatus ), sizeof( SERVICE_STATUS_PROCESS ),
        &dwBytesNeeded );

    CloseServiceHandle( theService );
    CloseServiceHandle( scm );

    if( result == 0 ) {
        return 0;
    }

    return ssStatus.dwCurrentState;
}


int main()
{
    SetConsoleTitle(_T("PoGoBag Server"));
    ClearConsoleToColors(1,15);

    //Check IIS service before start
    if(GetServiceStatus("W3SVC") == 4 )
    {
        MessageBox(CurrentConosoleWindow, "Port 80 on this PC is in use because \"IIS Server\"(Service:W3SVC) on this PC is running. Please stop it and try it again.", "Error", MB_OK|MB_ICONERROR);
    }
    else
    {
        cout<<"***Starting PoGoBag Server...This should take some time***"<<endl;
        thread StartBrowser(OpenLocalhost);
        thread StartRails(launch);
        StartBrowser.join();
        StartRails.join();
    }


    //launch();
    //ShellExecute(hwnd, "ruby", "c:\\MyPrograms", NULL, NULL, 0);
    //CreateProcess(rails.bat,s -p 80,
    return 0;
}
