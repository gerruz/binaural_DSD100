# binaural_DSD100
Code for generating binaural scenes from tracks in DSD100 dataset using Two!Ears Binaural simulator


The code was developed under the scope of my Master Thesis on "Binaural Source Separation with Convolution Neural Networks" [1]. In the report you can find the description of example binaural datasets and its separation results using DeepConvSep implementation [2].

binaural_DSD100 tool aims to be a flexible way of creating multiple binaural versions of DSD100 in order to test how separation algorithms perform in different conditions. Taking this flexibility approach in account, the code uses the Binaural Simulator provided by Two!Ears Auditory Model framework [3]. This integration permits the user to choose individual angular positions for each source in the horizontal plane. This position can change for every song in the dataset or not. User can also import any set of Head Related Transfer Functions (HRTFs) for the generation of the binaural signals. These transfer functions include monaural and interaural filtering, and also the acoustic response of the room. The default set of HRTFs were measured with a KEMAR dummy head in the anechoic chamber of the TU Berlin [4] with 1 meter distance between source and listener.

New datasets can be then generated, following the same structure as the original DSD100: the final binaural mixture is saved for both subsets (Test and Development), while individual positioned tracks are also saved. Position of the individual source signal and its location in the binaural mixture are the same.

Original DSD100 was introduced in MUS 2016 campaign [5] and consists of 100 professionally mixed songs of different styles. For each song, mixture and separate tracks are provided. Included instruments are classified as: vocals, drums, bass and other. The set is divided equally between Test and Development subsets, the latter intended for supervised training purposes. All tracks are stored as stereo WAV files with sample rate 44.1 kHz.


[1] Erruz, G. "Binaural Source Separation with Convolutional Neural Networks". Master Thesis. Music Technology Group (Universitat Pompeu Fabra, Barcelona). (2017) (to be published)

[2] Chandna, P., Miron, M. , Janer, J. & Gómez, E. "Monoaural audio source separation using deep convolutional neural networks". International Conference on Latent Variable Analysis and Signal Separation (2017).

[3] Two!Ears Team. Two!Ears Auditory Model. URL http://twoears.eu

[4] Wierstorf, H., Geier, M. & Spors, S. A free database of head related impulse response measurements in the horizontal plane with multiple distances. In Audio Engineering Society Convention 130 (Audio Engineering Society, 2011)

[5] MUS 2016. Professionally-produced music recordings task. Sixth Community-Based Signal Separation Evaluation Campaign (SiSEC). (2016). URL https://sisec.inria.fr/home/2016-professionally-produced-music-recordings/
