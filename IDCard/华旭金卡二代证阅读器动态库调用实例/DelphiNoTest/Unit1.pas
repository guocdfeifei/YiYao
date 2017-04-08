unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;
const
   PORT =1001 ; //ͨѶ�˿ں�  1001��ʾUSB1,1��ʾCOM1
   IFOpen=1;
type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
 //��̬���ö�̬��        
  function SDT_StartFindIDCard(iPort:integer;pucIIN:Pbytearray;iIfOpen:integer):integer;stdcall;external 'SDTAPI.DLL' name 'SDT_StartFindIDCard';
  function SDT_SelectIDCard(iPort:integer;pucSN:Pbytearray;iIfOpen:integer):integer;stdcall;external 'SDTAPI.DLL' name 'SDT_SelectIDCard';
  function SDT_ReadBaseMsg(iPort:integer;pucCHMsg:Pbytearray;puiCHMsgLen:PInteger;pucPHMsg:Pbytearray;puiPHMsgLen:PInteger;iIfOpen:integer):integer;stdcall;external 'SDTAPI.DLL' name 'SDT_ReadBaseMsg';

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  iResultValue:Integer;
  cModleSN: Array [0..255]of Char;//��ȫģ�����к�
  CardPUCIIN: array[0..255] of Byte;
  CardPUCSN: array[0..255] of Byte;
  pucCHMsg: array[0..256] of byte;
  pucPHMsg: array[0..1024] of byte;
  pucNewAddInfo: array[0..256] of byte;
  CardCHMsgLen: integer;
  CardPHMsgLen: integer;
begin

  //��ʼ�ҿ�:
  Memo1.Lines.Add('=============================');
  iResultValue := SDT_StartFindIDCard(PORT, @CardPUCIIN, IFOpen);
  If iResultValue = $80 Then  //�ҿ����ɹ���������û�п����߿�Ƭһֱ���ڴų���
  begin
    Memo1.Lines.Add('�ҿ�ʧ�ܣ�') ;
    Sleep(300);
    exit;
  end
  else if iResultValue=$2 then
  begin
    Memo1.Lines.Add('ͨѶ��ʱ,�����豸��') ;
    exit;
  end
  else if iResultValue = $9f Then
  begin
    iResultValue := SDT_SelectIDCard(PORT, @CardPUCSN, IFOpen);
    //����Ƭ�еı�ʶ
    If iResultValue = 144 Then
    begin
      //��ʼ��������Ա��Ϣ
      iResultValue := SDT_ReadBaseMsg(PORT, @pucchmsg, @CardCHMsgLen, @pucphmsg, @CardPHMsgLen, IFOpen);
      if iResultValue <> 144 Then
      begin
        Memo1.Lines.Add( '����ʧ�ܣ����ٴηſ�����');
        exit;
      end
      else   //�����������Ϣ����ʾ�ڽ�����
      begin
        Memo1.Lines.Add(WideCharLenToString(@pucchmsg,CardCHMsgLen))  ;
      end;
  end
  else
  begin
    Memo1.Lines.Add( '����ʧ�ܣ����ٴηſ�����');
    Exit;
  end;   
end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

end.
