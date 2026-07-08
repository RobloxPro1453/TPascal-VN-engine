unit VN_GFX;

interface
uses dos;

procedure InitMode13h;
procedure CloseMode13h;
procedure DrawBanner(bgfile: string);

implementation

var
   Screen: array[0..63999] of Byte absolute $A000:0000;

procedure InitMode13h;
var
   Regs: Registers;
begin
     Regs.AX := $0013;
     Intr($10, Regs);
end;

procedure CloseMode13h;
var
   Regs: Registers;
begin
     Regs.AX := $0003;
     Intr($10, Regs);
end;

procedure DrawBanner(bgfile: string);
var
   f: file;
begin
     Assign(f, bgfile);
     Reset(f, 1);
     BlockRead(f, Screen, SizeOf(Screen));
     Close(f);
end;

end.