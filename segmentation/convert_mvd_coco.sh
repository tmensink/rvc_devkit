#!/bin/sh
# Converts GT from VIPER into COCO format
# requires python and theses packages:
# pip install numpy
# pip install tqdm
# pip install umsgpack
# pip install pillow
# pip install git+git://github.com/waspinator/pycococreator.git@0.2.0


RVC_SEGM_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# All data is downloaded to subfolders of RVC_DATA_DIR; if this is not defined: use the root dir + /datasets
if [ -z "${RVC_DATA_DIR}" ]; then
  RVC_DATA_SRC_DIR=${RVC_SEGM_SCRIPT_DIR}/../datasets/
else
  RVC_DATA_SRC_DIR=${RVC_DATA_DIR}/
fi
  
#check if MVD has already been converted 
if [ ! -f "$RVC_DATA_SRC_DIR/mvd/panoptic/coco/training.json" ]; then
  echo "Converting MVD training data to COCO panoptic format..."

  if [ ! -d $RVC_SEGM_SCRIPT_DIR/seamseg ]; then
  # getting defined version of seamseg repo
    git -C $RVC_SEGM_SCRIPT_DIR clone https://github.com/mapillary/seamseg.git
    git -C $RVC_SEGM_SCRIPT_DIR/seamseg checkout 2b93918cd8d89e4f55fef1aac8ebec96c849379f
    #git -C $RVC_SEGM_SCRIPT_DIR/seamseg apply $RVC_SEGM_SCRIPT_DIR/seamseg.patch
  fi

  pushd ${RVC_SEGM_SCRIPT_DIR}/seamseg/scripts/data_preparation
    python prepare_vistas.py ${RVC_DATA_SRC_DIR}/mvd ${RVC_DATA_SRC_DIR}/mvd/panoptic
  popd
fi


RVC_DATA_SRC_DIR=
RVC_SEGM_SCRIPT_DIR=

echo "Finished converting."