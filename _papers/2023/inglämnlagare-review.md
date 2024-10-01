---
authors: "Joe Roe"
authors_short: "Roe, J."
date: "2023-11-27"
year: 2023
month: 12
title: "Peer Review Report For: Inglämnlagare: a tool for restructuring Swedish HER record site data for statistical analysis [version 2; peer review: 3 approved]"
journal: "F1000Research"
volume: 11
issue: 1370
doi: "10.5256/f1000research.157510.r222117"
reviewed: false
---

An open peer review of:

Löwenborg D and Antomonov F. Inglämnlagare: a tool for restructuring Swedish HER record site data for statistical analysis [version 2; peer review: 3 approved]. *F1000Research* 2023, 11:1370. <https://doi.org/10.12688/f1000research.126484.2>

## Review

The article describes a Python script that transforms data from the Swedish Historic Environment Record (HER) into a format more amenable for programmatic data analysis. Inglämnlagare addresses an increasingly common problem in computational archaeology: making institutional open data resources, which are often designed with specific use-cases and/or end-user software in mind, available for general use in modern data analysis pipelines. In that sense reminds me of a similar recently-developed R tool for processing sites records from US federal agencies[^1].

The use of the tool is clearly illustrated through a step-by-step case study of early Christian rectangular graves. It presumes an existing basic familiarity with SQL and the use of delimited text formats in a GIS environment. Users of the software will find this section especially useful because the documentation that accompanies the software itself (as of writing) is quite sparse, and mostly written in Swedish. Incidentally, the article also serves as a useful introduction to the structure of the Swedish HER in English, which helps make it more accessible to international research.

The tool itself is technically straightforward, consisting of a set of Python functions that parse HER data in CSV format, extract specified key–value pairs, and adds columns summarising the frequency of cooccurrence of each to the input data. Specifically, this function is applied to the "ing_lamn" field (ingående lämningar), which encodes arbitrary additional properties of the site as nested key–value pairs in what appears to  be JSON format. The user must convert the GPKG provided by the HER data portal to CSV format beforehand, and additional pre-processing is recommended in some circumstances. These are probably easy enough tasks for most potential users, but incorporating them into the software in a future version could be a way to make the software accessible to a broader audience. A command line interface facilitates the use of the tool outside of a Python environment (e.g. in QGIS, as described here, but also in scripted analyses or in other environments such as R) and includes multicore support to speed up the processing of larger datasets.

The implementation of this functionality relies heavily on regular expressions (somewhat misleadingly described here as something "within [?] computational linguistics"; in actuality a widely-used string pattern matching tool that has no model of natural language structures). I find this choice a little surprising, because the data in the  appears to be JSON and an efficient JSON parser is built into the Python standard library. Conversely, JSON is not a regular language so it is provably impossible to reliably parse it with regular expressions[^2]. It could well be that regular expressions were a compromise for performance reasons, or that I'm mistaken in my assumption that the contents of the "ing_lamn" is valid JSON. But either way, a concrete result of this choice is that that parsing is fragile and will almost certainly fail if the HER ever changes its output format for the ing_lamn field. This is always a problem with tools relient on external data structures or APIs, but is something users of Inglämnlagare should bear in mind if they want to ensure that their use of it is reproducible in the future.

As other reviewers have noted, the potential use cases of the tool are realistically limited to the specific task of 'rectangling' site property data from the Swedish HER. Users seeking to obtain a similar result with data from other sources will likely find it easier to use general tools for 'data wrangling', such as tidyr and related R packages[^3], the Python package pandas[^4], or [OpenRefine](https://openrefine.org), rather than trying to adapt this script. Nevertheless, writing software the does one thing and does it well is nothing to criticise! Inglämnlagare is a robust addition to the computational archaeologist's toolkit and will likely prove useful both to researchers that already work with Swedish HER and those who want to incorporate into broader analyses or reconcile it with other datasets.

## References

[^1]: Bergin S, Snitker G: ArchaeoSRP. *Advances in Archaeological Practice*. 2023. 1-11. <https://doi.org/10.1017/aap.2023.22>
[^2]: Is JSON a Regular Language?. *Stack Exchange*. <https://cstheory.stackexchange.com/questions/3987/is-json-a-regular-language>
[^3]: Wickham H, Vaughan D, Girlich M: tidyr: Tidy Messy Data. R package version 1.3.0. 2023. <https://tidyr.tidyverse.org/>
[^4]: pandas-dev/pandas: Pandas (v2.1.3). *Zenodo*. 2023. <https://doi.org/10.5281/zenodo.10107975>

## License

[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

## Full text

* [F1000Research](https://f1000research.com/articles/11-1370/v2#referee-response-222117)
