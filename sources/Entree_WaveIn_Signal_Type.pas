unit Entree_WaveIn_Signal_Type;

interface


const
   {N_Tampon = 500;
   N_Echantillonnage = 22050;
   N_Octets = 2;
   N_Bits = N_Octets*8;

   C_Amplitude = 1 shl (N_Bits-2);  }
   Entree_WaveIn_Tampon_NbEchantillons_NbBitsChiffre = 12;
   Entree_WaveIn_Tampon_NbEchantillons = 1 shl Entree_WaveIn_Tampon_NbEchantillons_NbBitsChiffre;


type
   //N_Octets=1
   //TEchantillon = ShortInt;
   //2
   TEchantillon = Smallint;



  TEntree_WaveIn_Signal = array[0..Entree_WaveIn_Tampon_NbEchantillons-1] of TEchantillon;
  TRSignal = array of real;




implementation

end.
