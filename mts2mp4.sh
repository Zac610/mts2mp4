#/bin/sh

#~ set -x

IFS=$(echo -en "\n\b")

mtsDir="/media/ZAC 64 REC/HBPVR"

mtsFile=$1
filmName=$2
startTime=$3
durationTime=$4

if [[ -z $1 ]]; then
	read -p "Inserisci il nome del file .mts: " mtsFile
	if [[ -z $mtsFile ]]; then
		exit
	fi
fi
if [[ -z $2 ]]; then
	read -p "Inserisci il nome del film [film]: " filmName
	if [[ -z $filmName ]]; then
		filmName="film"
	fi
fi
if [[ -z $3 ]]; then
	read -p "Inserisci il tempo di partenza: " startTime
fi
if [[ -z $4 ]]; then
	read -p "Inserisci la durata: " durationTime
fi

if  [[ -n $startTime ]]; then
	startTime="-ss $startTime"
fi

if  [[ -n $durationTime ]]; then
	durationTime="-t $durationTime"
fi

echo $mtsFile
echo $filmName
echo $startTime
echo $durationTime

rm command

for file in $(ls -1 "$mtsDir"/$mtsFile* | sort -V); do
	echo \""$file"\">>command
done

echo "cat $(tr '\n' ' '<command)> output.ts" > command1

. command1

rm command
rm command1

time avconv -i output.ts "$startTime" "$durationTime" -c:a copy -c:v libx264 -crf 18 -preset veryfast "$filmName".mp4

#~ rm -f output.ts
#command=${command}" -c:v libx264 -strict experimental "$outputFile

