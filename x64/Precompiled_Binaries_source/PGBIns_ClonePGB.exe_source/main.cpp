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
#include <fstream>
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


int silently_remove_directory(LPCTSTR dir) // Fully qualified name of the directory being   deleted,   without trailing backslash
{
  int len = strlen(dir) + 2; // required to set 2 nulls at end of argument to SHFileOperation.
  char* tempdir = (char*) malloc(len);
  memset(tempdir,0,len);
  strcpy(tempdir,dir);

  SHFILEOPSTRUCT file_op = {
    NULL,
    FO_DELETE,
    tempdir,
    "",
    FOF_NOCONFIRMATION |
    FOF_NOERRORUI |
    FOF_SILENT,
    false,
    0,
    "" };
  int ret = SHFileOperation(&file_op);
  free(tempdir);
  return ret; // returns 0 on success, non zero on failure.
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

int GitClone(){


    SHELLEXECUTEINFO ClonePoGoBag;
    ClonePoGoBag.cbSize = sizeof(SHELLEXECUTEINFO);
    ClonePoGoBag.fMask = (SEE_MASK_NOCLOSEPROCESS | SEE_MASK_FLAG_NO_UI | SEE_MASK_NO_CONSOLE);
    ClonePoGoBag.hwnd = NULL;
    ClonePoGoBag.lpVerb = NULL;
    ClonePoGoBag.lpFile = "git.exe";
    ClonePoGoBag.lpParameters = "clone \"https://github.com/dphuang2/PoGoBag.git\" \"C:\\PoGoBag\"";
    ClonePoGoBag.lpDirectory = "C:\\";
    ClonePoGoBag.nShow = SW_SHOW;
    ClonePoGoBag.hInstApp = NULL;
    ShellExecuteEx(&ClonePoGoBag);
    WaitForSingleObject(ClonePoGoBag.hProcess,INFINITE);

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
    cout<<"***Downloading latest PoGoBag source from GitHub***"<<endl;
    SetColor(1);
    if( (_access( "C:\\PoGoBag", 0 )) != -1 )
    {
        if ( silently_remove_directory("C:\\PoGoBag") !=0 )
        {
            MessageBox(CurrentConosoleWindow, "Looks like the folder C:\\PoGoBag Already existed on your PC, but we are unable to access this folder because it's in use. With this error, we might be unable to download newest PoGoBag to your PC.", "Error!", MB_OK|MB_ICONERROR);
        }
    }
    GitClone();
    Sleep(1000);
    SetColor(2);
    cout<<"***Verifying Downloaded content***"<<endl;
    SetColor(1);
    if( (_access( "C:\\PoGoBag\\Gemfile", 0 )) != -1 )
    {
        cout<<"Git Clone verified"<<endl;
    }
    else
    {
        cout<<"Error! The downloading procedure may had not been executed correctly"<<endl;
        SetColor(2);
        cout<<"***Retrying to download PoGoBag source from GitHub***"<<endl;
        SetColor(1);
        silently_remove_directory("C:\\PoGoBag");
        GitClone();
        Sleep(1000);
        SetColor(2);
        cout<<"***Verifying Downloaded content again***"<<endl;
        SetColor(1);
        if( (_access( "C:\\PoGoBag\\Gemfile", 0 )) != -1 )
        {
        cout<<"Git Clone verified"<<endl;
        }
        else
        {
            SetColor(4);
            cout<<"Error!!!"<<endl;
            std::ofstream file("PoGoBagInstaller_GitClone.error");
            file << "error";
            MessageBox(CurrentConosoleWindow, "We were unable to download PoGoBag from GitHub, sorry! Please Check your Internet connection!", "Error!", MB_OK|MB_ICONERROR);
        }
    }

    return 0;
}
