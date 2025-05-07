DRIVE_ID=13SvV4q7Sd2gp43jvljUdR_J_Bq90Za2b;

curl -c /tmp/cookie -s -L "https://drive.google.com/uc?export=download&id=${DRIVE_ID}" > /tmp/intermediate.html;
CONFIRM_TOKEN=$(grep -oP 'confirm=\K[^&]+' /tmp/intermediate.html);
curl -Lb -s "https://drive.google.com/uc?export=download&confirm=${CONFIRM_TOKEN}&id=${DRIVE_ID}" -o cuckoo.tar.gz

tar -xvzf cuckoo.tar.gz

FILE_PATH=$(find cuckoo -name club_records.csv | awk -F '/' '{printf "%s/%s/%s/%s",$1,$2,$3,$4}');

cd "$FILE_PATH";

min=9999;

while IFS= read -r line; do
cols=$(awk -F ',' '{print NF}' <<< "$line")
if [ $cols -lt $min ]; then
min=$cols
fi
done < club_records.csv

echo "Minimum number of rows in the csv file = ${min}"

while IFS= read -r line; do
awk -F ',' -v Min="$min" '{
for(i=1;i<=Min;i++){
printf "%s", $i
if(i < Min) printf ","
}
printf "\n"
}' <<< "$line";
done < club_records.csv > club_records_trimmed_version.csv;

echo "The trimmed version is saved in cuckoo/16/6/20/club_records_trimmed_version.csv";
