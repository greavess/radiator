% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sex_markers.R
\name{sexy_markers}
\alias{sexy_markers}
\title{sexy_markers finds sex-linked markers and re-assigns sex}
\usage{
sexy_markers(
  data,
  silicodata = NULL,
  strata = NULL,
  boost.analysis = FALSE,
  coverage.thresholds = 1,
  filters = TRUE,
  interactive.filter = TRUE,
  folder.name = NULL,
  parallel.core = parallel::detectCores() - 1,
  ...
)
}
\arguments{
\item{data}{(object or file) DArT file \code{.csv or .tsv}, VCF file \code{.vcf},
GDS file or object (\code{.gds}).\cr
See \code{\link[radiator]{read_dart}} or \code{\link[radiator]{read_vcf}} for more details.}

\item{silicodata}{(optional, file) A silico (dominant marker) DArT file \code{.csv or .tsv}.\cr
This can be count or genotyped data. Note that both \code{data} and
\code{silicodata} can be used at the same time.\cr
Default: \code{silicodata = NULL}.}

\item{strata}{(file) A tab delimited file with a minimum of
2 columns (\code{INDIVIDUALS, STRATA}) for VCF files and 3 columns for DArT files
(\code{TARGET_ID, INDIVIDUALS, STRATA}).
\itemize{
\item \code{TARGET_ID:} it's the column header of the DArT file.
\item \code{STRATA:} is the grouping column, here the sex info.
3 values: \code{M} for male, \code{F} for female and \code{U} for unknown.
Anything else is converted to \code{U}.
\item \code{INDIVIDUALS:} Is how you want your samples to be named.
}
Default: \code{strata = NULL}, the function will look for sex info in the
tidy data or GDS data (individuals.meta section).
You can easily build the strata file by starting with the output of these
functions: \code{\link[radiator]{extract_dart_target_id}} and \code{\link[radiator]{extract_individuals_vcf}}}

\item{boost.analysis}{(optional, logical) This method uses machine learning
approaches to find sex markers and re-assign samples in sex group.\cr
The approach is currently under construction.
Default: \code{boost.analysis = FALSE}.}

\item{coverage.thresholds}{(optional, integer) The minimum coverage required
to call a marker absent. For silico genotype data this must be < 1.\cr
Default: \code{coverage.thresholds = 1}.}

\item{filters}{(optional, logical) When \code{filters = TRUE}, the data will
be filtered for monomorphic loci, missingness of individuals and heterozygosity of individuals.\cr
CAUTION: we advice to use these filter, since not filtering or filtering too
stringently will results in false positive or false negative detections.\cr
Default: \code{filters = TRUE}.}

\item{interactive.filter}{(optional, logical) When \code{interactive.filter = TRUE}
the function will ask for your input to define thresholds. If \code{interactive.filter = FALSE}
the function expects additional arguments (see Advance mode).\cr
Default: \code{interactive.filter = TRUE}.}

\item{folder.name}{(optional,character) Name of the folder to store the results.
Default: \code{folder.name = NULL}. The name sexy_markers_datetime will be generated.}

\item{parallel.core}{(optional) The number of core used for parallel
execution during import.
Default: \code{parallel.core = parallel::detectCores() - 1}.}

\item{...}{(optional) Advance mode that allows to pass further arguments
for fine-tuning the function. Also used for legacy arguments (see details or
special section)}
}
\value{
The created object contains:
\enumerate{
\item A list with (1) the summarised SNP data per sex and
(2) the summarised silico data per sex. This should allow you to re-create the various plots.
\item A vector with the names of the sex-linked marker. One vector for each sex method.
\item A dataframe with a summary of the sex-linked markers and their sequence (if available).
}
}
\description{
This function identifies sex-linked markers putatively located on
heterogametic or homogametic chromosomes and re-assign the sex in a dataset
according to Y- or W-linked markers.\cr
The function work best in: DArT silico (counts) >
DArT counts or RADseq with allele read depth > DArT silico (genotypes) >
RADseq (genotypes) and DArT (1-row, 2-rows genotypes).
}
\details{
This function takes DArT and RAD-type data to find markers that have a specific
pattern that is linked to sex.\cr
The function hypothesizes the presence of sex-chromosomes in your
species/population. The tests are designed to identify markers that are
located on putative heterogametic (Y or W) or homogametic (X or Z) chromosomes.\cr
\emph{Note:} Violating Assumptions or Prerequisites (see below) can lead to
false positive or the absence of detection of sex-linked markers.
}
\section{Assumptions}{

\enumerate{
\item \strong{Genetic Sex Determination System} over a e.g. environmental-sex-determination system.
\item \strong{Genome coverage:} restriction sites randomly spread throughout the whole genome.
\item \strong{Mutations:} Processes such as sex-specific mutations
in the restriction sites could lead to false positive results.
\item \strong{Deletions/duplications:} Processes such as
sex-specific deletions or duplications could lead to false positive results.
\item \strong{Homology:} The existence of homologous sequences between the
homogametic and heterogametic chromosomes could lead to false negative
results.
\item \strong{Absence of population signal}
}
}

\section{Prerequisites}{

\enumerate{
\item \strong{Sample size:} Ideally, the data must have enough individuals (n > 100).
\item \strong{Batch effect:} Sex should be randomized on lanes/chips during sequencing.
\item \strong{Sex ratio:} Dataset with equal ratio work best.
\item \strong{Genotyping rate}: for DArT data, if the minimum call rate is
> 0.5 ask DArT to lower their filtering threshold.
RADseq data, lower markers missingness thresholds during filtering
(e.g. stacks \code{r} and \code{p}).
\item \strong{Identity-by-Missingness:} Absence of artifactual pattern
of missingness (\href{https://github.com/thierrygosselin/grur}{see missing visualization})
\item \strong{Low genotyping error rate:} see \code{\link{detect_het_outliers}}
and \href{https://github.com/eriqande/whoa}{whoa}.
\item \strong{Low heterozygosity miscall rate:} see \code{\link{detect_het_outliers}} and
\href{https://github.com/eriqande/whoa}{whoa}.
\item \strong{Absence of pattern of heterozygosity driven by missingness:}
see \code{\link[radiator]{detect_mixed_genomes}}.
\item \strong{Absence of paralogous sequences in the data}.
}
}

\section{Sex methods}{

\strong{Heterogametic sex-markers:}
\itemize{
\item \strong{Presence/Absence method}: To identify markers on Y or W chromosomes,
we look at the presence or
absence of a marker between females and males. More specifically, if a marker
is always present in males but never in females, they are putatively located
in the Y-chromosome; and vice versa for the W-linked markers.
}
\strong{Homogametic sex-markers:}
We have two different methods to identify markers on X or Z chromosomes:
\itemize{
\item \strong{Heterozygosity method:} By looking at the heterozygosity of a
marker between sexes, we can
identify markers that are always homozygous in one sex (e.g. males for an
XY system), while exhibiting an intermediate range of heterozygosity in the
other sex (0.1 - 0.5).
\item \strong{Coverage method:} If the data includes count information, this
function will look for
markers that have double the number of counts for either of the sexes.
For example if an XY/XX system is present, females are expected to have
double the number of counts for markers on the X chromosome.
}
}

\section{Advance mode}{


\emph{dots-dots-dots ...} allows to pass several arguments for fine-tuning the function:
\itemize{
\item \code{species}: To give your figures some meanings.
Default \code{species = NULL}.
\item \code{population}: To give your figures some meanings.
Default \code{species = NULL}.
\item \code{tau}: The quantile used in regression to distinguish homogametic markers
with the \strong{heterozygosity method}. See \code{\link[quantreg]{rq}}.\cr
Default \code{tau = 0.03}.
\item \code{mis.threshold.data}: Threshold to filter the SNP data on missingness.
Only if \code{interactive.filter = FALSE}.
\item \code{mis.threshold.silicodata}: Threshold to filter the silico data on
missingness. No default. Only if \code{interactive.filter = FALSE}.
\item \code{threshold.y.markers}: Threshold to select heterogametic sex-linked
markers from the SNP data with the \strong{presence/absence method}.No default.
Only if \code{interactive.filter = FALSE}.
\item \code{threshold.x.markers.qr}: Threshold to select homogametic sex-linked
markers from the SNP data with the \strong{heterozygosity method}. No default.
Only if \code{interactive.filter = FALSE}.
\item \code{zoom.data}: Threshold to subset the F/M ratio of mean SNP coverage.
Used to improve the histogram resolution to select a better \code{threshold.x.markers.RD}
threshold. No default. Only if \code{interactive.filter = FALSE}.
\item \code{threshold.x.markers.RD}: Threshold to select homogametic sex-linked
markers from the SNP data with the \strong{coverage method}.No default.
Only if \code{interactive.filter = FALSE}.
\item \code{zoom.silicodata}: Threshold to subset the F/M ratio of mean silico coverage.
Used to improve the histogram resolution to select a better \code{threshold.x.markers.RD.silico}
threshold. No default. Only if \code{interactive.filter = FALSE}.
\item \code{threshold.x.markers.RD.silico}: Threshold to select homogametic sex-linked
markers from the silico data with the \strong{coverage method}. No default.
Only if \code{interactive.filter = FALSE}.
\item \code{sex.id.input}: (integer) \code{sex.id.input = c(1, 2 or 3)}
to recalculate the sex based on (1) 'visual', (2) 'genetic SNP' or (3) 'genetic SILICO' sexID.
No default. Only if \code{interactive.filter = FALSE}.
\item \code{het.qr.input}: (integer) \code{het.qr.input = c(1 or 2)}
to plot the heterozygosity residual plot for (1) X-linked markers (heterozygous for females),
or (2) Z-linked markers (heterozygous for males). No default.
Only if \code{interactive.filter = FALSE}.
}
}

\section{Life cycle}{


Machine Learning approaches (Random Forest and Extreme Gradient Boosting Trees)
are currently been tested. They usually show a lower discovery rate but tend to
perform better with new samples.
}

\examples{
\dontrun{
# The minimum
sex.markers <- radiator::sexy_markers(
    data = "shark.dart.data.csv",
    strata = "shark.strata.tsv")
# This will use the default: interactive version and a list is created and to view the sex markers
}
}
\seealso{
Eric Anderson's \href{https://github.com/eriqande/whoa}{whoa} package.
}
\author{
Floriaan Devloo-Delva \email{Floriaan.Devloo-Delva@csiro.au} and with help from
Thierry Gosselin \email{thierrygosselin@icloud.com}
}
