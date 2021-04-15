# RansomwareTest
RansomwareTest consists of a word document with a macro and an additional powershell script which acts as a fake ransomware. It is meant to raise awareness for ransomware attacks.

To check whether you are prone to simple ransomware attacks, you just need to open the word document (RansomwareTest.docm). It will trigger a powershell (with the payload contained in dropper.ps1), download the fake ransomware (ifiwasevilyoudbefucked.ps1) from my domain seculancer.de and execute it.

<img src="./screenshot1.png" width="300pt" />

You might want to put ifiwasevilyoudbefucked.ps1 on your own server to make sure nothing evil is downloaded from my website. You only need to change the URL in the macro of the word document.

Functionality and GUI will be improved over time.
