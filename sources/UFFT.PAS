unit UFFT;

interface



uses USon, Math;


const FFT_Bit = 10;
      FFT_Echantillons = 1 shl FFT_Bit;
      N_EchCompresse = FFT_Echantillons;
      FFT_FreqBase = N_Echantillonnage / FFT_Echantillons;
      FFT_MaxIFreq = FFT_Echantillons div 2-1;



type TSpectre = array[0..FFT_Echantillons-1] of real;
     TSpectrePuiss = array[0..FFT_MaxIFreq] of TEchantillon;


procedure fft(iDebut:   integer;
    var  Signal: TSignal;
    var  SortieR:  TSpectre;
    var  SortieI:  TSpectre);


Procedure CreerSpectrePuiss(SpectreR, SpectreI: TSpectre; var spuiss:TSpectrePuiss);
Function FreqFondamental(var sp:TSpectrePuiss): real;
Function TesterFreq(var sp:TSpectrePuiss; freq: real): integer;

implementation

function InverserBits ( index, NumBits: integer ): integer;
var     i, rev: integer;
begin
    rev := 0;
    for i := 0 to NumBits-1 do begin
        rev := (rev SHL 1) OR (index AND 1);
        index := index SHR 1;
    end;

    result := rev;

end;





procedure fft (iDebut: integer; var  Signal:   TSignal;
                                  var  SortieR:  TSpectre;
                                  var  SortieI:  TSpectre);
var
    i, j, k, BlockSize, BlockEnd, ls: integer;
    delta_angle, delta_ar: double;
    alpha, beta: double;
    tr, ti, ar, ai: double;


begin

    ls := length(Signal);
    {Recopie le tableau à analyser dans l'ordre inverse "binairement"}
    for i := 0 to FFT_Echantillons-1 do begin
        j := InverserBits(i, FFT_Bit);

        SortieR[j] := Signal[(iDebut + i) mod ls];
        SortieI[j] := 0;
    end;

    BlockEnd := 1;
    {BlockEnd est l'ancienne valeur de BlockSize, ie la puissance de 2 précédente}
    BlockSize := 2;
    {BlockSize commence à 2, et incrémentera de puissance de 2 en puissance de
        2, jusqu'à NumSamples}
    while BlockSize <= FFT_Echantillons do begin
        delta_angle := 2*PI / BlockSize;
        alpha := sin ( 0.5 * delta_angle );
        alpha := 2.0 * alpha * alpha;
        //alpha = 1 - cos(delta_angle)
        beta := sin ( delta_angle );

        i := 0;
        {à chaque valeur de BlockSize, i va parcourir l'ensemble des multiples
          de BlockSize jusqu'à NumSamples}
        while i < FFT_Echantillons do begin
            ar := 1.0;    (* cos(0) *)
            ai := 0.0;    (* sin(0) *)

            for j := i to i+BlockEnd-1 do begin
                k := j + BlockEnd;
                //t := a * out[k] 
                tr := ar*SortieR[k] - ai*SortieI[k];
                ti := ar*SortieI[k] + ai*SortieR[k];
                SortieR[k] := SortieR[j] - tr;
                SortieI[k] := SortieI[j] - ti;
                SortieR[j] := SortieR[j] + tr;
                SortieI[j] := SortieI[j] + ti;
                delta_ar := alpha*ar + beta*ai;
                ai := ai - (alpha*ai - beta*ar);
                ar := ar - delta_ar;
            end;

            i := i + BlockSize;
        end;

        BlockEnd := BlockSize;
        BlockSize := BlockSize SHL 1; //on multiplie par 2 BlockSize
    end;

    for j := 0 to FFT_Echantillons-1 do
    Begin
        SortieR[j] := SortieR[j]/FFT_Echantillons;
        SortieI[j] := SortieI[j]/FFT_Echantillons;
    End;

end;






Procedure CreerSpectrePuiss(SpectreR, SpectreI: TSpectre; var spuiss:TSpectrePuiss);
var j:integer;
Begin
    for j := 0 to FFT_Echantillons div 2-1 do
        spuiss[j] := round(sqrt(sqr(SpectreR[j]) + sqr(SpectreI[j])
                                     + sqr(SpectreR[FFT_Echantillons-j-1]) + sqr(SpectreI[FFT_Echantillons-j-1])))

End;







Function FreqFondamental(var sp:TSpectrePuiss): real;
const nmaxharmo = 10;
      eprec = 0.2;
      seuilsonore = 10;
      seuilsonoresp = 0;

var pics: array of integer;
    poids: array of real;
    i, iminfreq, imaxfreq,
    j, jmaxpic, jmaxpoids,
    k, f, numharmo :integer;
    maxpoids, r, e: real;
    freq: array of real;
    sommeFreq: real;
    lastnumharmo, lastvolmaxvol: integer;
Begin

    j := -1;

    iminfreq := round(50 / FFT_FreqBase);
    imaxfreq := round(4000 / FFT_FreqBase);

    For i := iminfreq to imaxfreq do
           if (sp[i] - sp[i-1] >= 0) and (sp[i] - sp[i+1] >=0) and (sp[i] > seuilsonore) then
                     Begin
                         inc(j);
                         setlength(pics,j+1);
                         pics[j] := i;

                     End;


    setlength(poids, length(pics));

    jmaxpic := high(pics);

    if jmaxpic = -1 then
        Begin
            result := 0;
            Exit;
        End;

    for j := 0 to jmaxpic do
           Begin
               poids[j] := sp[pics[j]];

               for k := j+1 to jmaxpic do
                      Begin
                           r := pics[k] / pics[j];
                           e := r - round(r);
                           poids[j] := poids[j] + power(1 - abs(e),4) * sp[pics[k]];
                      End;


           End;

    maxpoids := 0;
    jmaxpoids := 0;

    for j := 0 to jmaxpic do
          Begin
                 if poids[j] > maxpoids then
                 Begin
                        maxpoids := poids[j];
                        jmaxpoids := j;
                 End;


          End;

    j := jmaxpoids;

    f := -1;

    lastnumharmo := 0;
    result := pics[j] * FFT_FreqBase;
    for k := j+1 to jmaxpic do
          Begin

                r := pics[k] / pics[j];
                numharmo := round(r);
                if numharmo <> lastnumharmo then
                Begin
                   lastvolmaxvol := 0;
                   lastnumharmo := numharmo;
                End;
                e := r - round(r);
                if abs(e) <= eprec then
                      Begin

                          if (sp[pics[k]] > lastvolmaxvol) and (sp[pics[k]] > seuilsonoresp) then
                          Begin

                               inc(f);
                               setlength(freq, f+1);
                               freq[f] := pics[k] * FFT_FreqBase / numharmo;
                               lastvolmaxvol := sp[pics[k]];
                               result := pics[k] * FFT_FreqBase / numharmo;
                          end;
                      End;
          End;



    sommeFreq := pics[j]* FFT_FreqBase;


    for f := 0 to high(Freq) do
            sommeFreq := sommeFreq + Freq[f];



    result := sommeFreq / (length(Freq) + 1);




End;





Function TesterFreq(var sp:TSpectrePuiss; freq: real): integer;
    {la fonction teste si le spectre contient un son de la fréquence freq
       elle renvoit un genre de poids, d'autant plus grand que le son est
       suceptible de contenir la fréquence freq}
var i, s, numharmo: integer;

Begin
      s := 0;
      numharmo := 0;

      i := 0;

      while i <= FFT_MaxIFreq do
      Begin
          if i > 0 then
                s := s + sp[i];
          
          inc(numharmo);
          i := round(numharmo * freq / FFT_FreqBase);

      End;


      result := s;

End;



end.
