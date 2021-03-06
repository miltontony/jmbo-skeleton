#! /bin/bash

# Will move to Genshi templates in future

# Defaults
SITE=site
PORT=9000
CREATE_DIR=/tmp

# Prompt for params
echo -n "Egg name, eg. jmbo-myapp. [enter]: "
read EGG
echo -n "Django app name, eg. myapp. [enter]: "
read APP
echo -n "Site name, eg. ghana. This is useful if you have different sites forming a logical whole, eg. a site per country. (default=site) [enter]: "
read asite
if [ -n "$asite" ];
then
    SITE=$asite
fi    
echo -n "Port. The port Django listens on. (default=9000) [enter]: "
read aport
if [ -n "$aport" ];
then
    PORT=$aport
fi    
echo -n "Source code directory. (default=/tmp) [enter]: "
read adir
if [ -n "$adir" ];
then
    CREATE_DIR=$adir
fi    

# Create the project
PROJECT_DIR=${CREATE_DIR}/${APP}
APP_DIR=${PROJECT_DIR}/${APP}
mkdir $PROJECT_DIR
cp bootstrap.py ${PROJECT_DIR}/
cp buildout.cfg ${PROJECT_DIR}/
cp .gitignore ${PROJECT_DIR}/
cp -r buildout_templates ${PROJECT_DIR}/
cp dev_base.cfg ${PROJECT_DIR}/
cp dev_basic_site.cfg ${PROJECT_DIR}/dev_basic_${SITE}.cfg
cp dev_smart_site.cfg ${PROJECT_DIR}/dev_smart_${SITE}.cfg
cp dev_web_site.cfg ${PROJECT_DIR}/dev_web_${SITE}.cfg
cp -r skeleton ${PROJECT_DIR}/${APP}
cp live_base.cfg ${PROJECT_DIR}/
cp live_basic_site.cfg ${PROJECT_DIR}/live_basic_${SITE}.cfg
cp live_smart_site.cfg ${PROJECT_DIR}/live_smart_${SITE}.cfg
cp live_web_site.cfg ${PROJECT_DIR}/live_web_${SITE}.cfg
cp qa_base.cfg ${PROJECT_DIR}/
cp qa_basic_site.cfg ${PROJECT_DIR}/qa_basic_${SITE}.cfg
cp qa_smart_site.cfg ${PROJECT_DIR}/qa_smart_${SITE}.cfg
cp qa_web_site.cfg ${PROJECT_DIR}/qa_web_${SITE}.cfg
cp setup.py ${PROJECT_DIR}/
cp versions.cfg ${PROJECT_DIR}/
touch ${PROJECT_DIR}/AUTHORS.rst
touch ${PROJECT_DIR}/CHANGELOG.rst
touch ${PROJECT_DIR}/README.rst
if [ "$SITE" != "site" ];
then
    mv ${APP_DIR}/settings_dev_basic_site.py ${APP_DIR}/settings_dev_basic_${SITE}.py
    mv ${APP_DIR}/settings_dev_smart_site.py ${APP_DIR}/settings_dev_smart_${SITE}.py
    mv ${APP_DIR}/settings_dev_web_site.py ${APP_DIR}/settings_dev_web_${SITE}.py
    mv ${APP_DIR}/settings_live_basic_site.py ${APP_DIR}/settings_live_basic_${SITE}.py
    mv ${APP_DIR}/settings_live_smart_site.py ${APP_DIR}/settings_live_smart_${SITE}.py
    mv ${APP_DIR}/settings_live_web_site.py ${APP_DIR}/settings_live_web_${SITE}.py
    mv ${APP_DIR}/settings_qa_basic_site.py ${APP_DIR}/settings_qa_basic_${SITE}.py
    mv ${APP_DIR}/settings_qa_smart_site.py ${APP_DIR}/settings_qa_smart_${SITE}.py
    mv ${APP_DIR}/settings_qa_web_site.py ${APP_DIR}/settings_qa_web_${SITE}.py
fi

# Change strings in the newly copied source
sed -i s/name=\'jmbo-skeleton\'/name=\'${EGG}\'/ ${PROJECT_DIR}/setup.py
sed -i "15s/.*/    ${EGG}/" ${PROJECT_DIR}/dev_base.cfg
sed -i "15s/.*/    ${EGG}/" ${PROJECT_DIR}/live_base.cfg
sed -i "15s/.*/    ${EGG}/" ${PROJECT_DIR}/qa_base.cfg
sed -i s/skeleton/${APP}/g ${PROJECT_DIR}/*.cfg
sed -i s/skeleton/${APP}/g ${APP_DIR}/*.py
sed -i s/skeleton/${APP}/g ${APP_DIR}/migrations/*.py
if [ "$SITE" != "site" ];
then
    sed -i s/_site/_${SITE}/g ${PROJECT_DIR}/*_${SITE}.cfg
    sed -i s/-site/-${SITE}/g ${PROJECT_DIR}/*_${SITE}.cfg
fi

# Indicate version of jmbo-skeleton used to create project
VERSION=`sed "5q;d" setup.py | awk -F= '{print $2}'`
echo "Changelog" > ${PROJECT_DIR}/CHANGELOG.rst
echo "=========" >> ${PROJECT_DIR}/CHANGELOG.rst
echo "" >> ${PROJECT_DIR}/CHANGELOG.rst
echo "0.1" >> ${PROJECT_DIR}/CHANGELOG.rst
echo "---" >> ${PROJECT_DIR}/CHANGELOG.rst
echo "Project generated by jmbo-skeleton $VERSION" >> ${PROJECT_DIR}/CHANGELOG.rst 
echo "" >> ${PROJECT_DIR}/CHANGELOG.rst

