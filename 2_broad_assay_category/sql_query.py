query1 = """select distinct
assay_id
, year
, description
, assay_type
from 
chembl_35.assays assays
join chembl_35.docs on assays.doc_id = docs.doc_id
join chembl_35.target_dictionary td on assays.tid = td.tid
where
assays.src_id = 1
and td.tid != 22226
and description is not NULL
and assay_type in ('B', 'F')"""