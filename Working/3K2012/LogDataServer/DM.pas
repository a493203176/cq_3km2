unit DM;

interface

uses
  SysUtils, Classes, DB, ADODB,windows;

type
  TDMFrm = class(TDataModule)
    ADOConn: TADOConnection;
    ADOQuery1: TADOQuery;
    ADOSelect: TADOQuery;
    ADODel: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMFrm: TDMFrm;

implementation
uses LDShare,IniFiles,Grobal2,LogDataMain;
{$R *.dfm}

procedure TDMFrm.DataModuleCreate(Sender: TObject);
var
  Conf: TIniFile;
  Year, Month, Day: Word;
  LogFile:string;
begin
  Conf := TIniFile.Create('.\LogData.ini');
  if Conf <> nil then begin
    sBaseDir := Conf.ReadString('Setup', 'BaseDir', sBaseDir);
    Conf.Free;
  end;

  DecodeDate(Date, Year, Month, Day);

//Ŀ¼������,�򴴽�Ŀ¼
  if not FileExists(sBaseDir) then CreateDirectoryA(PChar(sBaseDir), nil);

  LogFile :=sBaseDir + IntToStr(Year) + '-' + IntToString(Month) + '-' + IntToString(Day)+ '.mdb';

//��־�ļ�������,�򴴽�
  if not FileExists(LogFile) then begin
   if FrmLogData.CreateAccessFile(LogFile,'') then begin
      if not ADOconn.Connected then FrmLogData.ConnectedAccess(LogFile,''); //�������ݿ�
       with ADOQuery1 do  //�������ݱ�
         begin
          close;
          SQL.Clear;
          SQL.Add('Create Table Log (��� Counter,���� string,��ͼ string,X���� integer,Y���� integer,');
          SQL.Add('�������� string,��Ʒ����  string,��ƷID  string,��¼  string,���׶���  string,ʱ�� DateTime)');
          ExecSQL;
         end;
    end;
  end else if not ADOconn.Connected then FrmLogData.ConnectedAccess(LogFile,''); //�������ݿ�
end;

procedure TDMFrm.DataModuleDestroy(Sender: TObject);
begin
  ADOconn.Close ;
end;

end.