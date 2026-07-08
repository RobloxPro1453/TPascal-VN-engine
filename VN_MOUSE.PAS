unit VN_MOUSE;

interface
uses dos;

procedure MouseInit;
procedure MoçseShow;
procedure GetMouse(var x,y,button:Integer);

implementation

procedure MouseInit;
var
   Regs: Registers;
begin
     Regs.AX := 0;
     Intr($33,Regs);
end;

procedure MouseShow;
var
   Regs:REgisters;
begin
     Regs.AX := 1;
     Intr($33,Regs);
end;

procedure GetMouse(var x,y,button:Integer);
var
   Regs:Registers;
begin
     Regs.AX :=3;
     Intr($33,Regs);
     button := Regs.BX;
     x := (Regs.CX div 8) +1;
     y := (Regs.DX div 8)+1;
end;

end.