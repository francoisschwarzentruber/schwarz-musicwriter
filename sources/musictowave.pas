unit musictowave;

interface


const NB_OCTETS_UN_ECH = 2;

CONST HEADER:ARRAY[0..43]OF BYTE=(
$52,$49,$46,$46, $00,$00,$00,$00, $57,$41,$56,$45, $66,$6D,$74,$20,
$10,$00,$00,$00, $01,$00,$01,$00, $44,$AC,$00,$00, $88,$58,$01,$00,
$02,$00,$10,$00, $64,$61,$74,$61, $00,$00,$00,$00);

type TFonctionTimbre = function(numharmo: integer; t, duree:integer): real;





TYPE THEAD=RECORD
Tag1       : ARRAY[1..4]OF CHAR;  { 00..03  Constante "RIFF"       }
Size1      : LONGINT;             { 04..07  Filesize-8             }
Tag2       : ARRAY[1..14]OF CHAR; { 08..21  Constante "WAVEfmt..." }
Mode       : WORD;                { 22..23  Mono or Stereo         }
Freq       : LONGINT;             { 24..27  Frequence (Hz)         }
BytePerSec : LONGINT;             { 28..31  Freq*NbrByte           }
NbrByte    : WORD;                { 32..33  (Format div 8)*Mode    }
Format     : WORD;                { 34..35  8 or 16 bits           }
Tag3       : ARRAY[1..4]OF CHAR;  { 36..39  Constante "data"       }
Size2      : LONGINT;             { 40..43  Filesize-116           }
END;

TMusicToWave = class(TObject)
private
       head: THEAD; 
       ech: array of SmallInt;

public
       constructor Create(nbech: integer);

       destructor Destroy;
       procedure WriteOnDisk(nomfich: string);

       procedure AddRawSinus(d, f: integer; freq, ampli: real);
       procedure AddDing(d, f: integer; freqbase, amplibase : real; timbre: TFonctionTimbre);
end;


function TimbreFlute(numharmo: integer; t, duree:integer): real;
function TimbreTrompette(numharmo: integer; t, duree:integer): real;
function TimbreClarinette(numharmo: integer; t, duree:integer): real;
function TimbreOrgue(numharmo: integer; t, duree:integer): real;
function TimbrePiano(numharmo: integer; t, duree:integer): real;

implementation


    {function TimbreFlute(numharmo: integer; t, duree:integer): real;
    var env: real;
    Begin
         env := 1;

         if t < 2000 then
             env := t / 800;

         if duree - t < 3000 then
            env := (duree - t) / 3000;

         result := env / sqr(sqr(numharmo));
    End;}

    function TimbreClarinette(numharmo: integer; t, duree:integer): real;
    const dureeattaque = 2000;
    const ampliattaque = 10;
    const dureeapresattaque = 1000;
    const fin = 100000;
    const lambda = 0.00001;
    var env: real;
    Begin
         env := 1;

         if t < dureeattaque then
             env := ampliattaque*t / dureeattaque
         else if t < dureeattaque+dureeapresattaque then
             env := 1 + (ampliattaque-1)*(dureeattaque+dureeapresattaque-t)/(dureeapresattaque);
               if duree - t < 3000 then
            env := (duree - t) / 3000;
            if (numharmo mod 2 = 0) or (numharmo = 1) then
            result := env / sqr(numharmo) else result := env / sqrt(numharmo);
    End;

    function TimbreOrgue(numharmo: integer; t, duree:integer): real;
    const dureeattaque = 2000;
    const ampliattaque = 10;
    const dureeapresattaque = 1000;
    const fin = 100000;
    const lambda = 0.00001;
    var env: real;
    Begin
         env := 1;

         if t < dureeattaque then
             env := ampliattaque*t / dureeattaque
         else if t < dureeattaque+dureeapresattaque then
             env := 1 + (ampliattaque-1)*(dureeattaque+dureeapresattaque-t)/(dureeapresattaque);
              if duree - t < 3000 then
            env := (duree - t) / 3000;
            if (numharmo mod 2 = 0) or (numharmo = 1) then
            result := env / sqrt(sqrt(numharmo)) else result := env / sqr(sqr(numharmo));
    End;


    function TimbrePiano(numharmo: integer; t, duree:integer): real;
    const dureeattaque = 2000;
    const ampliattaque = 10;
    const dureeapresattaque = 1000;
    const fin = 100000;
    const lambda = 0.00003;
    var env: real;
    Begin

         if t < dureeattaque then
             env := ampliattaque*t / dureeattaque
         else if t < dureeattaque+dureeapresattaque then
             env := 1 + (ampliattaque-1)*(dureeattaque+dureeapresattaque-t)/(dureeapresattaque)
         else
             env := exp(-lambda*(t - (dureeattaque+dureeapresattaque)));

            if (numharmo mod 2 = 0) or (numharmo = 1) then
            result := env / sqr(numharmo) else result := env / sqrt(numharmo);
    End;
    
    function TimbreTrompette(numharmo: integer; t, duree:integer): real;
    var env: real;
    Begin
         env := 1;

         if t < 2000 then
             env := t / 800;

         if duree - t < 3000 then
            env := (duree - t) / 3000;

         result := env / sqrt(numharmo);
    End;

    function TimbreFlute(numharmo: integer; t, duree:integer): real;
    var env: real;
    Begin
         env := 1;

         if t < 2000 then
             env := t / 800;

         if duree - t < 3000 then
            env := (duree - t) / 3000;

         result := env / sqr(numharmo);
    End;



constructor TMusicToWave.Create(nbech: integer);
var filesize: integer;
Begin
    head := THEAD(HEADER);

    filesize := nbech * 2 + 44;
    head.Size1 := filesize - 8;
    head.Size2 := filesize - 116;

    setlength(ech, nbech);

End;

destructor TMusicToWave.Destroy;
begin
    Finalize(ech);
    inherited Destroy;
end;


procedure TMusicToWave.WriteOnDisk(nomfich: string);
var f : File;
    ta: integer;
Begin
     Assign(f, nomfich);
     Rewrite(f, 1);

     BlockWrite(f, head, 44);
     ta := length(ech) * NB_OCTETS_UN_ECH;
     BlockWrite(f, ech[0], ta);

     CloseFile(f);
End;


procedure TMusicToWave.AddRawSinus(d, f: integer; freq, ampli: real);
var i: integer;
Begin
    for i := d to f do
        ech[i] := ech[i] + round(ampli*sin(2*PI*freq*i / 44100));
End;


procedure TMusicToWave.AddDing(d, f: integer; freqbase, amplibase : real; timbre: TFonctionTimbre);
var n, i, nvval:integer;
Begin
     for n := 1 to 10 do
         for i := d to f do
             Begin
                 nvval := ech[i] + round(amplibase * timbre(n, i-d, f-d)
                                        *sin(2*PI*(freqbase*n)*i / 44100));
                if abs(nvval) < 32000 then ech[i] := nvval;
             End;
End;

end.
