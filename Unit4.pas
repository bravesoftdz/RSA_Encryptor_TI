unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  arrayInt = array[1..10000] of integer;
  TForm4 = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    lbl4: TLabel;
    btn1: TButton;
    edt1: TEdit;
    edt2: TEdit;
    btn2: TButton;
    mmo1: TMemo;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure edt1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  flagText: Boolean;
  FileNameText, OutputFileName: String;


implementation

{$R *.dfm}

procedure TForm4.btn1Click(Sender: TObject);
var
  openDialog : TOpenDialog;
begin
  flagText:= True;
  openDialog := TOpenDialog.Create(openDialog);
  openDialog.Title:= '�������� ���� ��� ��������';
  openDialog.InitialDir := GetCurrentDir;
  openDialog.Options := [ofFileMustExist];
  openDialog.Filter := 'Text file|*.*';
  openDialog.FilterIndex := 1;
  if openDialog.Execute then
  begin
    FileNameText:= openDialog.FileName;
  end
  else
    begin
      Application.MessageBox('����� ����� ��� �������� ����������!', '��������������!');
      flagText:=False;
    end;
  openDialog.Free;

  lbl1.Caption := FileNameText;
end;

function Nod(a, b: integer): integer;
begin
  while a * b <> 0 do
    if a > b then
      a := a mod b
    else
      b := b mod a;
  Nod := a + b;
end;

function evklid(a, b: integer): integer;
var
  d0, d1, x0, x1, y0, y1, q, d2, x2, y2: integer;
begin
  d0:=a; d1:=b;
  x0:=1; x1:=0;
  y0:=0; y1:=1;
  while d1>1 do
  begin
    q:=d0 div d1;
    d2:=d0 mod d1;
    x2:=x0-q*x1;
    y2:=y0-q*y1;
    d0:=d1; d1:=d2;
    x0:=x1; x1:=x2;
    y0:=y1; y1:=y2;
  end;
  if y1 < 0 then
    evklid := y1 + a
  else
    evklid := y1;
end;

function fast_exp(a: longword; z, n: longword): longword;
var
  x: longword;
begin
  x := 1;
  while z <> 0 do
  begin
    while (z mod 2) = 0 do
    begin
      z := z div 2;
      a := (a * a) mod n;
    end;
    z := z - 1;
    x := (x * a) mod n;
  end;
  fast_exp := x;
end;

procedure sieveEratosthenes(n : integer; var arrayPrimeNumbers : arrayInt; var k : integer);
var
  i, x : integer;
  tempArray : array[1..100000] of byte;
begin
	i := 3;
	while i <= trunc(sqrt(n)) do
	begin
		x := i * i;
		while x <= n do
		begin
			tempArray[x] := 1;
			x := x + i;
		end;
		i := i + 2;
	end;
	i := 3;
	arrayPrimeNumbers[1] := 2;
	k := 2;
	while i <= n do
	begin
		if (tempArray[i] = 0) and (i mod 2 <> 0) then
		begin
			arrayPrimeNumbers[k] := i;
			inc(k);
		end;
		inc(i);
	end;
	dec(k);
end;

function SwapW(i: Word): Word;
begin
  asm
    mov ax, [i]
    xchg al,ah
    mov [i], ax
  end;
  SwapW := i;
end;


procedure TForm4.btn2Click(Sender: TObject);
var
  q, p, n, fi, i, j, e, d, quantityPrimeNumbers: integer;
  countText : int64;
  arr : array of word;
  c : array of integer;
  arrayPrimeNumbers : arrayInt;
  flag : boolean;
  temp : int64;
  b : byte;
  File_text: file of word;
begin
  if flagText then
  begin
    countText := -1;
    AssignFile(File_text, FileNameText);
    reset(File_text);
    while not Eof(File_text) do
    begin
      inc(countText);
      SetLength(arr, countText+1);
      read(File_text, arr[countText]);
      arr[countText] := SwapW(arr[countText]);
    end;
    CloseFile(File_text);

    e := StrToInt(edt2.Text);
    n := StrToInt(edt1.Text);

    sieveEratosthenes(n, arrayPrimeNumbers, quantityPrimeNumbers);

    flag := false;
    for i:= 1 to quantityPrimeNumbers - 1 do
    begin
      for j:= (i+1) to quantityPrimeNumbers do
      begin
        if arrayPrimeNumbers[i] * arrayPrimeNumbers[j] = n then
        begin
          p := arrayPrimeNumbers[i];
          q := arrayPrimeNumbers[j];
        end;
      end;
    end;

    fi := (p - 1) * (q - 1);
    d := evklid(fi, e);
    mmo1.Text := mmo1.Text + 'q = ' + IntToStr(q) + '; p = ' + IntToStr(p) + '; d = ' + IntToStr(d) + #13#10;

    OutputFileName := FileNameText + '.atackRSA';
    AssignFile(output, OutputFileName);
    Rewrite(output);
    //writeln('Decryption:');
    for i:= 0 to countText-1 do
    begin
      write(chr(fast_exp(arr[i], d, n)));
      //mmo1.Text := mmo1.Text + IntToStr(fast_exp(arr[i], d, n)) + ' ';
    end;
    CloseFile(output);
  end;
end;
procedure TForm4.edt1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

end.
