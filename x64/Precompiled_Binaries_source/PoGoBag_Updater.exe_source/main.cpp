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



//The PoGoBag server process is still running! Terminate the running process and proceed to update?
//HWND consoleWnd = GetConsoleWindow();

int TerminateAnswer = 0;
HWND CurrentConosoleWindow = GetConsoleWindow();

void CheckProcessAndAsk(const char *filename)
{
    HANDLE hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
    //HANDLE hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, NULL);
    PROCESSENTRY32 pEntry;
    pEntry.dwSize = sizeof (pEntry);
    BOOL hRes = Process32First(hSnapShot, &pEntry);
    while (hRes)
    {
        if (strcmpi(pEntry.szExeFile, filename) == 0)
        {
            HANDLE hProcess = OpenProcess(PROCESS_TERMINATE, 0, (DWORD) pEntry.th32ProcessID);
            if (hProcess != NULL)
            {

                TerminateAnswer = MessageBox(CurrentConosoleWindow, "The PoGoBag server process is still running! Terminate the running process and proceed to update?", "Process Detected!", MB_YESNO|MB_ICONQUESTION);
                if ( TerminateAnswer == IDYES )
                {
                    TerminateProcess(hProcess, 9);
                    CloseHandle(hProcess);
                    while (hRes)
                    {
                        if (strcmpi(pEntry.szExeFile, filename) == 0)
                        {
                            HANDLE hProcess = OpenProcess(PROCESS_TERMINATE, 0, (DWORD) pEntry.th32ProcessID);
                            if (hProcess != NULL)
                            {
                                TerminateProcess(hProcess, 9);
                                CloseHandle(hProcess);
                            }
                        }
                        hRes = Process32Next(hSnapShot, &pEntry);
                    }
                }

                else
                {
                CloseHandle(hProcess);
                break;
                }
            }

        }
        hRes = Process32Next(hSnapShot, &pEntry);
    }
    CloseHandle(hSnapShot);

}


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









int GitClone(){
SHELLEXECUTEINFO ClonePoGoBag;
ClonePoGoBag.cbSize = sizeof(SHELLEXECUTEINFO);
ClonePoGoBag.fMask = (SEE_MASK_NOCLOSEPROCESS | SEE_MASK_FLAG_NO_UI | SEE_MASK_NO_CONSOLE);
ClonePoGoBag.hwnd = NULL;
ClonePoGoBag.lpVerb = NULL;
//StartRails80.lpFile = "cmd.exe";
//StartRails80.lpParameters = "/c \"rails s -p 80\"";
ClonePoGoBag.lpFile = "git.exe";
ClonePoGoBag.lpParameters = "clone \"https://github.com/dphuang2/PoGoBag.git\" \"C:\\PoGoBag\"";
ClonePoGoBag.lpDirectory = "C:\\";
ClonePoGoBag.nShow = SW_SHOW;
ClonePoGoBag.hInstApp = NULL;
ShellExecuteEx(&ClonePoGoBag);
WaitForSingleObject(ClonePoGoBag.hProcess,INFINITE);
return 0;
}

int RakeDbSetup(){
SHELLEXECUTEINFO dbsetup;
dbsetup.cbSize = sizeof(SHELLEXECUTEINFO);
dbsetup.fMask = (SEE_MASK_NOCLOSEPROCESS | SEE_MASK_FLAG_NO_UI | SEE_MASK_NO_CONSOLE);
dbsetup.hwnd = NULL;
dbsetup.lpVerb = NULL;
//StartRails80.lpFile = "cmd.exe";
//StartRails80.lpParameters = "/c \"rails s -p 80\"";
dbsetup.lpFile = "C:\\Ruby23-x64\\bin\\ruby.exe";
dbsetup.lpParameters = " \"C:\\Ruby23-x64\\bin\\rake\" db:setup";
dbsetup.lpDirectory = "C:\\PoGoBag";
dbsetup.nShow = SW_SHOW;
dbsetup.hInstApp = NULL;
ShellExecuteEx(&dbsetup);
WaitForSingleObject(dbsetup.hProcess,INFINITE);
return 0;
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


//"C:\Ruby23-x64\bin\ruby.exe"  "C:\Ruby23-x64\bin\rails" s -p 80

int main()
{
    SetConsoleTitle(_T("PoGoBag Upgrade Utility"));
    ClearConsoleToColors(3,15);
    CheckProcessAndAsk("ruby.exe");

    if ( TerminateAnswer != 7 ) //continue delete&upgrade
    {
        if ( silently_remove_directory("C:\\PoGoBag") ==0 )
        {
        //removal ok,proceed git clone
            SetColor(6);
            cout<<"***Downloading PoGoBag source from Github***"<<endl;
            SetColor(1);
            GitClone();
            SetColor(6);
            cout<<"***Configuring PoGoBag database***"<<endl;
            SetColor(1);
            RakeDbSetup();
            MessageBox(CurrentConosoleWindow, "All Done!", "Info", MB_OK);

        }
        else
        {
            if( (_access( "C:\\PoGoBag", 0 )) != -1 )
            {
            SetColor(4);
            cout<<"Access to C:\\PoGoBag denied!"<<endl;
            MessageBox(CurrentConosoleWindow, "Files(C:\\PoGoBag) are locked because it's being used by another program. Please resolve it and try again.", "Upgrade Failed", MB_OK|MB_ICONERROR);//failed,because process running ,abort
            }
            else
            {
            //deletion failed because folder did not exist before, continue
                SetColor(6);
                cout<<"***Downloading PoGoBag source from Github***"<<endl;
                SetColor(1);
                GitClone();
                SetColor(6);
                cout<<"***Configuring PoGoBag database***"<<endl;
                SetColor(1);
                RakeDbSetup();
                MessageBox(CurrentConosoleWindow, "All Done!", "Info", MB_OK);
            }
        }

    }
    else
    {
        cout<<"Upgrade aborted!"<<endl;
        MessageBox(CurrentConosoleWindow, "Upgrade has been canceled.", "Info", MB_OK|MB_ICONERROR);
    }


    return 0;
}
