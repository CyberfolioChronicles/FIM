<h1>FIM - File Integrity Monitoring using PowerShell</h1>

 ### [YouTube Demonstration](https://www.youtube.com/watch?v=uDd5R2uEIL0&t=317s)

<h2>Description</h2>
In this hands-on tutorial, we'll walk you through the process of creating a small portfolio project focused on File Integrity Monitoring. You'll learn how to harness the power of PowerShell to detect unauthorized changes to files, ensuring the integrity and security of your system.
<br />


<h2>Languages and Utilities Used</h2>

- <b>PowerShell</b> 

<h2>Environments Used </h2>

- <b>Windows 10</b> (21H2)

<h2>Flowchart:</h2>

<br/>
<img src="https://i.imgur.com/6XRx72A.png" height="80%" width="80%"/>
<br />
<br />
<h2>walk-through:</h2>

<p align="center">
Ask users what would they like to choose: <br/>
<img src="https://i.imgur.com/ii29mRf.png" height="80%" width="80%" alt="FIM steps"/>
<br />
<br />
Baseline.txt file creation:  <br/>
<img src="https://i.imgur.com/U3IUASy.png" height="80%" width="80%" alt="FIM steps"/>
<br />
<br />
Hash values of files: <br/>
<img src="https://i.imgur.com/cduiCux.png" height="80%" width="80%" alt="FIM steps"/>
<br />
<br />
Alert when file content is changed:  <br/>
<img src="https://i.imgur.com/A69eqr5.png" height="80%" width="80%" alt="FIM steps"/>
<br />
<br />
Alert when a new file is created:  <br/>
<img src="https://i.imgur.com/QjTH5lH.png" height="80%" width="80%" alt="FIM steps"/>
<br />
<br />
Integrity compromise alert when a file is deleted:  <br/>
<img src="https://i.imgur.com/QjTH5lH.png" height="80%" width="80%" alt="FIM steps"/>
</p>
<h2>Code explanation:</h2>
This PowerShell script defines functions and provides a basic menu-driven interface for two main tasks related to file monitoring:

1. Collect a New Baseline (Option A):

It begins by checking if a baseline file named baseline.txt exists in the current directory and deletes it if it does.
Then, it initializes an empty hashtable called $baseline to store file path-hash pairs.
It retrieves a list of files in the .\Files directory.
For each file, it calculates the SHA-512 hash using the Calculate-File-Hash function and stores the file path and hash in the $baseline hashtable.
Finally, it updates the baseline.txt file with the new baseline data using the Update-Baseline function.

2. Begin Monitoring Files with Saved Baseline (Option B):

It loads the baseline data from the baseline.txt file into a hashtable called $fileHashDictionary using the Get-Baseline function.
It enters an infinite loop where it periodically checks for changes in the files within the .\Files directory.
For each file, it calculates the SHA-512 hash using the Calculate-File-Hash function.
It compares the calculated hash with the hash stored in the $fileHashDictionary hashtable.
If the hash is the same, it indicates that the file has not changed.
If the hash is different, it prints a message indicating that the file has changed.
It also checks if files in the baseline no longer exist and prints a message if they have been deleted. These deleted files are removed from the $fileHashDictionary.
After checking all files, it updates the baseline.txt file with any changes in the monitored files using the Update-Baseline function.
The script allows users to choose between collecting a new baseline or monitoring files based on the saved baseline. When monitoring files, it continuously checks for changes in the files and reports these changes to the console.

Please note that this script assumes a specific directory structure (the .\Files directory) and uses the SHA-512 algorithm for file hashing. Users can interact with the script by selecting option 'A' or 'B' at the command prompt to perform the desired operation.
