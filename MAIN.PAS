Program VisualNovel;
uses crt, VN_UI, VN_CORE, VN_MOUSE, VN_GFX;

var
   f:Text;
   gamename,name,text, filename, choicecountstr, labelstr, envanter, itemname: string;
   choicecount, errcode, I, seciliindex,FareX,FareY,Tiklama :Integer;
   secenekler: MenuArray;
   tus: Char;
   Started:Boolean;

begin
     clrscr;
     envanter := '';
     {writeln('senaryo dosyasini girin (.txt ile birlikte)');
     readln(filename);
     if filename = '' then Error(0,0);}
     filename := 'scenario.txt';
     Check(filename);

     Assign(f, filename);
     Reset(f);



     readln(f,gamename);
     if (Pos('@NAME',gamename)=1) and (not EOF(f)) then begin
        gamename := Copy(gamename,7,16);

        if FileExists('banner.bin') then begin
               InitMode13h;
               DrawBanner('banner.bin');
               readln;
               CloseMode13h;
        end;

        DrawMainMenu;
        MouseInit;
        MouseShow;
        DrawBox(20,5,60,9);
        SetText(20,5,60,9,gamename);
     end;


     Started := False;
     repeat
           GetMouse(Farex,FareY,Tiklama);
           if Tiklama = 1 then begin
              if (FareX >= 30) and (FareX <= 50) and (FareY>= 14) and (FareY <= 16) then
              begin
                   Started := True;
              end
              else if (FareX >= 30) and (FareX <= 50) and (FareY>= 18) and (FareY <= 20) then
              begin
                   Halt;
              end;
           end;

     until Started = True;

     MouseHide;
     clrscr;
     DrawBox(1, 1, 80, 17);
     SetText(2, 2, 79, 15, '[ gorsellerin yerleri (usenmezsem 13h modunda eklerim) burda olcak ]');


     while not EOF(f) do
     begin
          readln(f, name);

          while (name = '') and (not EOF(f)) do
          begin
               readln(f, name);
          end;

          if (Pos('@',name)=0) and (not EOF(f)) then
          begin
               readln(f, text);
               DrawTextBox(text, name);
               while KeyPressed do begin ReadKey; end;
               readln;
          end
          else if (Pos('@CHOICE',name)=1) and (not EOF(f)) then
          begin
               choicecountstr := Copy(name,9,2);
               Val(choicecountstr,choicecount,errcode);
               if errcode = 0 then
               begin
                    for I:= 1 to choicecount do
                    begin
                         if not EOF(f) then
                         begin
                              readln(f, text);
                              secenekler[I] := text;
                         end;
                    end;

                    seciliindex := 1;
                    repeat
                         DrawChoiceMenu(secenekler, choicecount, seciliindex);
                         tus := ReadKey;

                         if tus = #0 then
                         begin
                              tus := ReadKey;
                              if tus = #72 then
                              begin
                                   if seciliindex > 1 then seciliindex := seciliindex - 1;
                              end
                              else if tus = #80 then
                              begin
                                   if seciliindex < choicecount then seciliindex := seciliindex + 1;
                              end;
                         end;
                     until tus = #13;

                    ClearGraphs;

                    for I := 1 to (seciliindex - 1) do
                    begin
                         if not EOF(f) then readln(f, labelstr);
                    end;
                    if not EOF(f) then
                    begin
                         readln(f,labelstr);
                         if Pos('@GOTO', labelstr) = 1 then
                         begin
                              labelstr := Copy(labelstr,7,4);
                              JumpToLabel(f,labelstr);
                         end;
                    end;
               end;
          end
          else if (Pos('@GIVE',name)=1) and (not EOF(f)) then
          begin
               itemname := Copy(name,6,20);
               itemname := Trim(itemname);
               envanter := envanter + ';' + itemname;
               DrawTextBox(Concat(itemname, ' aldin!!!'),'');
               while KeyPressed do begin ReadKey; end;
               readln;
          end
          else if (Pos('@DROP',name)=1) and (not EOF(f)) then
          begin
               itemname := Copy(name,6,20);
               itemname := Trim(itemname);
               I := Pos(itemname,envanter);
               if I <> 0 then
               begin
                    Delete(envanter, I-1, Length(itemname)+1);
                    DrawTextBox(Concat(itemname, ' envanterden atildi!!!'),'');
                    while KeyPressed do begin ReadKey; end;
                    readln;
               end;
          end
          else if (Pos('@HAS',name)=1) and (not EOF(f)) then
          begin
               itemname := Copy(name,6,20);
               itemname := Trim(itemname);
               I := Pos(' ', itemname);
               if I > 0 then
               begin
                    labelstr := Copy(itemname, I + 1, 4);
                    itemname := Copy(itemname, 1, I - 1);
                    if Pos(itemname, envanter) <> 0 then
                    begin
                         JumpToLabel(f, labelstr);
                    end;
               end;
          end
          else if (Pos('@LABEL',name)=1) then
          begin
               labelstr:=Copy(name,8,4);
          end
          else if (Pos('@GOTO',name)=1) then
          begin
               labelstr := Copy(name,7,4);
               JumpToLabel(f, labelstr);
          end;
     end;

     Close(f);
     clrscr;
     SetText(1, 1, 80, 25, '--- OYUN BITTI ---');
     readln;
end.