# iEye open-source oculomotor visualization & analysis toolbox for MATLAB/Octave

Presently, work-in-progress - refactoring functions to better compartmentalize data/operations. GUI not yet functional, but preprocessing should work. See examples/example_preproc.m and associated functions.

## Data model
Updated version will no longer use base variables - all data will be encapsualted in ii_* structs:
**ii_cfg** - data about the run, including channels recorded, trial times, blinks, saccades, and condition labels
**ii_data** - data from each channel (X, Y, Pupil, etc) over the entire timeseries, sampled at ii_cfg.hz
**ii_sacc** - information about each saccade detected from ii_data, so each field of ii_sacc has size(ii_cfg.saccades,1) elements

Our goal will be to convert timeseries data into scores, via preprocessing operations, then saccade sorting operations, then scoring operations. All of which operate on these structures, and GUIs must all update these structures, and update plots according to updated data within these structures (approx model/view/controller design, but not quite).

Conversion from ii_data to ii_sacc should occur **only** at the very end of all preprocessing, once no further data cleaning is necessary. This is because any changes to ii_data are NOT echoed to ii_sacc at present, and so they can easily become out-of-sync.





DISCLAIMER

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
