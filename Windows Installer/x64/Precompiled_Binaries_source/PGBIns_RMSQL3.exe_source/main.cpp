#include <iostream>
#define _WIN32_WINNT 0x0500
#include <windows.h>

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <winver.h>
#include <process.h>
#include <Tlhelp32.h>
#include <winbase.h>
#include <string.h>
#include <tchar.h>
using namespace std;




//HWND CurrentConosoleWindow = GetConsoleWindow();

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


void SetColor(int ForgC)
{
     WORD wColor;
     //This handle is needed to get the current background attribute

     HANDLE hStdOut = GetStdHandle(STD_OUTPUT_HANDLE);
     CONSOLE_SCREEN_BUFFER_INFO csbi;
     //csbi is used for wAttributes word

     if(GetConsoleScreenBufferInfo(hStdOut, &csbi))
     {
          //To mask out all but the background attribute, and to add the color
          wColor = (csbi.wAttributes & 0xF0) + (ForgC & 0x0F);
          SetConsoleTextAttribute(hStdOut, wColor);
     }
     return;
}



int RMSQL3(){
SHELLEXECUTEINFO RemoveSQLITE3;
RemoveSQLITE3.cbSize = sizeof(SHELLEXECUTEINFO);
RemoveSQLITE3.fMask = (SEE_MASK_NOCLOSEPROCESS | SEE_MASK_FLAG_NO_UI | SEE_MASK_NO_CONSOLE);
RemoveSQLITE3.hwnd = NULL;
RemoveSQLITE3.lpVerb = NULL;
RemoveSQLITE3.lpFile = "C:\\Ruby23-x64\\bin\\ruby.exe";
RemoveSQLITE3.lpParameters = " -x \"C:\\Ruby23-x64\\bin\\gem.cmd\" uninstall sqlite3";
RemoveSQLITE3.lpDirectory = NULL;
RemoveSQLITE3.nShow = SW_SHOW;
RemoveSQLITE3.hInstApp = NULL;
ShellExecuteEx(&RemoveSQLITE3);
WaitForSingleObject(RemoveSQLITE3.hProcess,INFINITE);
return 0;
}








int main()
{
    HWND hConsoleWnd = GetConsoleWindow();
    if (hConsoleWnd != 0)
    {
    HMENU hConsoleMenu = GetSystemMenu(hConsoleWnd, FALSE);
    if (hConsoleMenu != 0)
    RemoveMenu(hConsoleMenu, SC_CLOSE, MF_BYCOMMAND);
    }


    SetConsoleTitle(_T("PoGoBag Server Installer for Windows"));


    ClearConsoleToColors(1, 15);
    SetColor(2);
    cout<<"***Removing Bugged SQLite3***"<<endl;
    SetColor(1);
    RMSQL3();
    return 0;
}
