unit UMidiFile;

interface



const resolnoire = 240;



var f:File of Byte;
    piste :array of Byte;
    ip: LongWord; //indice courant d'écriture dans piste
    m_Channel: integer; {canal MIDI courant}

Procedure m_ResetPiste;
Procedure m_WriteEntete(nbpiste: integer);
Procedure m_WritePiste;
Procedure m_AddDelayTime(value: Longword);
Procedure m_AddNote(NoteOn: Boolean; valn, vel: Byte);
Procedure m_AddFinDePiste;
Procedure m_AddTempo(Tempo : LongWord);
Procedure m_AddMetronome;
Procedure m_AddInstrument(num: Byte);
Procedure m_AddControle(c, v: Byte);
Procedure m_AddNom(n: string);
Procedure m_WriteIntlEnvers(a: integer);





implementation


Procedure m_WriteIntlEnvers(a: integer);
var t: array[0..3] of Byte;
    i: integer;
Begin
Move(a, t, 4);

for i := 3 downto 0 do
     BlockWrite(f, t[i], 1);

End;

Procedure m_WriteWordlEnvers(a: word);
var t: array[0..1] of Byte;
    i: integer;
Begin
Move(a, t, 2);

for i := 1 downto 0 do
     BlockWrite(f, t[i], 1);

End;


Procedure m_WriteEntete(nbpiste: integer);
Begin
BlockWrite(f, 'MThd', 4);
m_WriteIntlEnvers(6);
m_WriteWordlEnvers(1); //format
m_WriteWordlEnvers(nbpiste); // nb pistes
m_WriteWordlEnvers($00F0); //résol noire
End;





Procedure m_WritePiste;
Begin
BlockWrite(f, 'MTrk',4);
m_WriteIntlEnvers(ip);
BlockWrite(f, piste[0], ip);
End;



Procedure m_ResetPiste;
Begin
      Setlength(piste, 0);
      ip := 0;
End;



Procedure m_AddTextePur(s: string);
var ls, i: LongWord;
Begin
ls := length(s);
Setlength(piste, ip + ls);
for i := 0 to ls-1 do
    piste[ip+i] := Ord(s[i+1]);

inc(ip, ls);

End;


Procedure m_AddNote(NoteOn: Boolean; valn, vel: Byte);
const t = 3;
Begin
Setlength(piste, ip + t);
if NoteOn then
     piste[ip] := $90 or m_Channel
else
     piste[ip] := $80 or m_Channel;

piste[ip+1] := valn;
piste[ip+2] := vel;

inc(ip, t);


End;


Procedure m_AddFinDePiste;
const t = 3;
Begin
Setlength(piste, ip + t);
piste[ip] := $FF;
piste[ip+1] := $2F;
piste[ip+2] := $00;
inc(ip, t);
End;


Procedure m_AddDelayTime(value: Longword);
var buffer: longWord;
Begin

   buffer := value and $7F;
   value := value shr 7;

   while value <> 0 do
   Begin
     buffer := buffer shl 8;
     buffer := buffer or (value and $7F) or $80;
     value := value shr 7;
   End;


   while true do
   Begin
      Setlength(piste, ip + 1);
      piste[ip] := Buffer and $FF;
      inc(ip);
      if buffer and $80 <> 0 then
          buffer := buffer shr 8
      else
          break;
   End;

End;

Procedure m_AddTempo(Tempo : LongWord);
const t = 6;
Begin
Setlength(piste, ip + t);
piste[ip] := $FF;
piste[ip+1] := $51;
piste[ip+2] := $03;
piste[ip+3] := (Tempo shr 16) and $FF;
piste[ip+4] := (Tempo shr 8) and $FF;
piste[ip+5] := (Tempo) and $FF;
inc(ip, t);
End;


Procedure m_AddMetronome;
const t = 7;
Begin
Setlength(piste, ip + t);
piste[ip] := $FF;
piste[ip+1] := $58;
piste[ip+2] := $04;
piste[ip+3] := $04;
piste[ip+4] := $02;
piste[ip+5] := $18;
piste[ip+6] := $08;
inc(ip, t);
End;


Procedure m_AddInstrument(num: Byte);
const t = 2;
Begin
Setlength(piste, ip + t);
piste[ip] := $C0 or m_Channel;
piste[ip+1] := num;
inc(ip, t);
End;


Procedure m_AddControle(c, v: Byte);
const t = 3;
Begin
Setlength(piste, ip + t);
piste[ip] := $B0 or m_Channel;
piste[ip+1] := c;
piste[ip+2] := v;
inc(ip, t);
End;


Procedure m_AddNom(n: string);
const t = 3;
Begin
Setlength(piste, ip + t);
piste[ip] := $FF;
piste[ip+1] := $03;
piste[ip+2] := length(n);
inc(ip, t);

m_AddTextePur(n);


End;


end.
