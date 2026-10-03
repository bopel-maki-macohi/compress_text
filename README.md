# Compress Text

Compresses text into a base64 of a list of indices into a string containing every letter used.

## Usage

### Encode

Will compress the data

and turn the data into a .JSON

and save it to the destination directory.

`haxe run.hxml -D targ="<destination_directory>" -D str="<some_text>"`

`haxe run.hxml -D targ="<destination_directory>" -D file="<input_filepath>"`

### Decode

Will take the compressed data JSON

and turn it back into the original data

and save it to the destination directory as a .txt

`haxe run.hxml -D decode -D targ="<destination_directory>" -D str="<some_text>"`

`haxe run.hxml -D decode -D targ="<destination_directory>" -D file="<input_filepath>"`
