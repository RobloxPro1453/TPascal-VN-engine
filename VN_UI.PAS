unit VN_UI;

interface
uses crt, dos;

const TEXT_DELAY = 15;
      CHOICE_OFFSET = 3;

type
   MenuArray = array[1..5] of string;

procedure DrawBox(x1,y1,x2,y2: Integer);
procedure SetText(x1,y1,x2,y2:Integer; str:string);
procedure DrawTextBox(str:string; name:string);
procedure ClearGraphs;
procedure DrawChoiceMenu(choicelist:MenuArray; choicecount, secili:Integer);
procedure DrawMainMenu;


implementation

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
     PosY := (WinHeight div 2) + 1;

     if PosX < 1 then PosX := 1;
     if PosY < 1 then PosY := 1;

     GotoXY(PosX, PosY);
     write(str);
     Window(1,1,80,25);
end;

procedure DrawTextBox(str:string; name:string);
var
   NameLength, I: Integer;
begin
     NameLength := Length(name);
     Window(1, 1, 80, 25);
     GotoXY(1, 17);
     Write(#204);
     for I:= 0 to 2 do write(#205);
     write('[ ',name,' ]');
     for I:=0 to (70 - NameLength) do write(#205);
     write(#185);

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

procedure ClearGraphs;
begin
     Window(2, 2, 79, 16);
     clrscr;
     Window(1, 1, 80, 25);
end;

procedure DrawChoiceMenu(choicelist:MenuArray; choicecount, secili:Integer);
var
   I, y1,y2:Integer;
begin
     Window(2, 2, 79, 16);
     clrscr;
     Window(1, 1, 80, 25);

     y1 := 3;
     y2 := 5;

     for I:=1 to choicecount do begin
          if I = secili then
          begin
               TextColor(Cyan);
               DrawBox(20,y1,60,y2);
               SetText(21, y1 + 1, 59, y2 - 1, Concat('> ', choicelist[I], ' <'));
          end
          else
          begin
               TextColor(White);
               DrawBox(20,y1,60,y2);
               SetText(21, y1 + 1, 59, y2 - 1, choicelist[I]);
          end;

          y1 := y1 + CHOICE_OFFSET;
          y2 := y2 + CHOICE_OFFSET;
     end;
     TextColor(White);
end;

procedure DrawMainMenu;
begin
     clrscr;
     TextColor(LightCyan);
     DrawBox(30,14,50,16);
     SetText(30,14,50,16, 'OYNA');

     DrawBox(30,18,50,20);
     SetText(30,18,50,20, 'CIKIS');
     TextColor(White);
end;

end.