# Rilevamento automatico di segnali bioacustici tramite tecniche di Deep Learning
Tale progetto ha lo scopo di dimostrare l’efficacia degli approcci Deep Learning nell’ambito applicativo del Passive Acoustic Monitoring ed in particolare nel rilevamento automatico dei fischi del delfini. Si intende testare la capacità di rilevamento di due Reti Neurali allenate su due dataset distinti. Nel particolare è stato studiato il comportamento di una Vanilla CNN e una VGG-16 preallenata.
#### Librerie Python necessarie
- `tensorflow`
- `sklearn`
- `PIL`
- `numpy`
- `random`
- `matplotlib`
#### Matlab Tools necessari
- `Signal Processing Toolbox`

## Preprocess MATLAB
Per la prima fase di pre-processing eseguire lo script Matlab `preprocessWav.m`. E' necessario inserire nella variabile 'folder' il percorso della cartella contenente i file '.wav' ed il percorso di destinazione delle immagini '.png' elaborate.

## Preprocess Python
Per la seconda fase di pre-processing eseguire il codice in `preprocess.ipynb`. Eseguire cella per cella per monitorare il corretto svolgimento. Necessario inserire i percorsi delle cartelle contenenti le immagini e il file '.mat' contenente le etichette. 

## Hyperparameter Optimization
Ottimizzazione degli iperparametri della Vanilla CNN. Eseguire `hyperOpt.ipynb`.

## Addestramento Reti
- `vanillacnn.ipynb`
- `vgg16.ipynb`

## Test
- `testVanillaCNN.ipynb`
- `testVgg16.ipynb`
