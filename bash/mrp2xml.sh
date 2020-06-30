GOLD=$1
shift
for MRP in $*; do
  mkdir -p ${MRP%.mrp}
  XML=${MRP%.mrp}.xml
  python toolkit/mtool/main.py $MRP $XML --read mrp --write ucca || exit 1
  csplit -zk $XML '/^<root/' -f '' -b "${MRP%.mrp}/%03d.xml" {553} > /dev/null
  python toolkit/evaluate_standard.py ${MRP%.mrp} $GOLD -q --summary-file ${MRP%.mrp}.scores.txt
done

