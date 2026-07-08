unit VN_CORE;

interface
uses crt, VN_UI;

procedure Error(e,line:Integer);
procedure Check(filename:string);
function Trim(str:string):string;
procedure JumpToLabel(var filevar: Text; target: string);
function FileExists(filename:string):Boolean;


implementation

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
     else if e = 3 then
     begin
          FullMessage := Concat('HATA at line ', linestr, ': choice prefix error!');
          SetText(16, 8, 64, 16, FullMessage);
     end
     else
          SetText(16, 8, 64, 16, 'HATA: unknown error!');

     TextColor(White);
     readln;
     Halt;
end;

procedure Check(filename:string);
var
   f:Text;
   name,text,choicecountstr:string;
   currentline,choicecount,errcode,I:Integer;
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

          if (Pos('@',name)=0) and (not EOF(f)) then
          begin
               readln(f, text);
               currentline := currentline + 1;

               if Length(name) > 20 then Error(1, currentline)
               else if Length(text) > 240 then Error(2, currentline);
          end
          else if (Pos('@CHOICE',name)=1) and (not EOF(f)) then
          begin
               choicecountstr := Copy(name,9,2);
               Val(choicecountstr,choicecount,errcode);
               if errcode <> 0 then Error(3, currentline)
               else
               begin
                    for I:= 1 to choicecount do
                    begin
                         if not EOF(f) then
                         begin
                              readln(f, text);
                              currentline := currentline + 1;
                         end;
                    end;
               end;
          end;
     end;
     Close(f);
end;

function Trim(str:string):string;
begin
     while (Length(str)> 0) and (str[Length(str)]=' ') do
     begin
          Delete(str,Length(str),1);
     end;
     Trim := str;
end;

procedure JumpToLabel(var filevar: Text; target: string);
var
   line: string;
   found: Integer;
begin
     Reset(filevar);
     found := 0;
     while (not EOF(filevar)) and (found = 0) do
     begin
          readln(filevar, line);
          if (Pos('@LABEL', line) = 1) and (Copy(line, 8, 4) = target) then
          begin
               found := 1;
          end;
     end;
     if found = 0 then
     begin
          Close(filevar);
          clrscr;
          WriteLn('HATA: Gitmek istediginiz label bulunamadi: ', target);
          readln;
          Halt;
     end;
end;

function FileExists(filename:string):Boolean;
var
   f:file;
begin
     Assign(f,filename);
     {$I-}
     Reset(f);
     {$I+}
     if IOResult = 0 then begin
        FileExists := True;
        Close(f);
     end
     else
         FileExists := False;
end;



end.