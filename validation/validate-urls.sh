# !/bin/bash
DOCS_PATH=../docs
FLAG_404=0

for doc_file in $(ls ${DOCS_PATH})
do
	
    echo -e "\n##### doc_file = $doc_file #####"
    for url_path in $(awk -F'[()]' '{print $2}' ${DOCS_PATH}/$doc_file | grep "http*")
    do
    RESPONSE=`curl -o /dev/null -s -w "%{http_code}\n" "$url_path"`
    if [ ${RESPONSE} -eq 404 ]
    then
        echo "++ $RESPONSE, Page does not exist: $url_path, please review"
        FLAG_404=1
    else
        echo "++ $RESPONSE, Page ($url_path) exists"
    fi
done
done

if [ ${FLAG_404} -eq 1 ]
then
    echo -e "\n++ Change the wrong URLs"
    exit 1
fi