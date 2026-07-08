Program HelloWorld;
uses crt;

const TEXT_DELAY = 15;

procedure DrawBox(x1,y1,x2,y2: Integer);
var
   I:Integer;
   InnerWidth:Integer;
begin
     InnerWidth := (x2 - x1) - 1;

     GotoXY(x1,y1);
     write(#201);
     for I:=1 to InnerWidth do write(#205);
     write(#187);

     for I:=1 to (y2 - y1 - 1) do
     begin
          GotoXY(x1, y1 + I);
          write(#186, ' ':InnerWidth, #186);
     end;

     GotoXY(x1,y2);
     write(#200);
     for I:=1 to InnerWidth do write(#205);
     write(#188);
end;

procedure SetText(x1,y1,x2,y2:Integer; str:string);
var
   WinWidth, WinHeight: Integer;
   PosX, PosY: Integer;
begin
     WinWidth := (x2 - x1) + 1;
     WinHeight := (y2 - y1) + 1;

     Window(x1, y1, x2, y2);

     PosX := (WinWidth - Length(str)) div 2 + 1;
     PosY := (WinHeight) div 2;

     if PosX < 1 then PosX := 1;

     GotoXY(PosX, PosY);
     write(str);

     Window(1,1,80,25);
end;

procedure Error(e,line:Integer);
var
   linestr:string;
   FullMessage:string;
begin
     clrscr;
     DrawBox(15, 7, 65, 17);
     Str(line,linestr);
     TextColor(Red);
     
     if e = 1 then
     begin
          FullMessage := Concat('HATA at line ', linestr, ': name too long!');
          SetText(16, 8, 64, 16, FullMessage);
     end
     else if e = 2 then
     begin
          FullMessage := Concat('HATA at line ', linestr, ': text too long!');
          SetText(16, 8, 64, 16, FullMessage);
     end
     else
          SetText(16, 8, 64, 16, 'HATA: unknown error!');

     TextColor(White);
     readln;
     Halt;
end;

procedure DrawTextBox(str:string; name:string);
var
   NameLength, I: Integer;
begin
     NameLength := Length(name);

     Window(1, 1, 80, 25);

     GotoXY(1, 17);
     Write(#204); {normali 201}
     for I:= 0 to 2 do write(#205);
     write('[ ',name,' ]');
     for I:=0 to (70 - NameLength) do write(#205);
     write(#185); {normali 187}

     for I:= 0 to 5 do
     begin
          GotoXY(1, 18 + I);
          write(#186, ' ':78, #186);
     end;

     GotoXY(1, 24);
     write(#200);
     for I:=1 to 78 do write(#205);
     write(#188);

     Window(7, 19, 73, 23);
     clrscr;
     GotoXY(1, 1);

     for I:=1 to Length(str) do
     begin
          write(str[I]);
          Delay(TEXT_DELAY);
     end;

     Window(1, 1, 80, 25);
end;

procedure Check(filename:string);
var
   f:Text;
   name,text:string;
   currentline:Integer;
begin
     currentline := 0;
     Assign(f, filename);
     Reset(f);

     while not EOF(f) do
     begin
          readln(f, name);
          currentline := currentline + 1;

          while (name = '') and (not EOF(f)) do
          begin
               readln(f, name);
               currentline := currentline + 1;
          end;
          if not EOF(f) then
          begin
               readln(f, text);
               currentline := currentline + 1;

               if Length(name) > 20 then Error(1, currentline)
               else if Length(text) > 240 then Error(2, currentline);
          end;
     end;
     Close(f);
end;

var
   f:Text;
   name,text, filename: string;
begin
     clrscr;

     writeln('senaryo dosyasini girin (.txt ile birlikte)');
     readln(filename);
     if filename = '' then Error(0,0);
     Check(filename);

     clrscr;
     DrawBox(1, 1, 80, 17);
     SetText(2, 2, 79, 15, '[ gorsellerin yerleri burda olcak ]');

     Assign(f, filename);
     Reset(f);

     while not EOF(f) do
     begin
          readln(f, name);

          while (name = '') and (not EOF(f)) do
          begin
               readln(f, name);
          end;
          if not EOF(f) then
          begin
               readln(f, text);
               
               DrawTextBox(text, name);
               while KeyPressed do
               begin
                    ReadKey;
               end;

               readln;
          end;
     end;

     Close(f);
     clrscr;
     SetText(1, 1, 80, 25, '--- OYUN BITTI ---');
     readln;
end.