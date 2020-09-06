#include <math.h>
#include <stdio.h>
#include "steve_matlab_header.h"
void cdecl flip_array(float *data,int nn, int M, int is_complex) {
   static unsigned char mask[256];
	static int first_call=1,i,j,k;
   float tempr,tempi;
	int nnM=nn*M;
  	int lognn=0;
  	for (i=nn;i>1;lognn++,i>>=1);  //get log2
   if (first_call) {
   	first_call=0;
  		for (i=0;i<256;i++) {
    		long int i1,i2;
    		// flip i to produce j
    		for (i1=i,i2=256,j=0;i2>1;i2>>=1,i1>>=1)
      		j=(j<<1)+(i1&1);
    		mask[i]=(unsigned char) j;
  		}
   }
  	for (i=0;i<nn;i++) {
    	long int i1,i2;
    	if (nn>256) {
    		for (j=0,i1=i,i2=lognn;i2>0;i2-=8,i1>>=8)
      		j=(j<<8)+mask[i1&255];
    		j>>=-i2;
    	}
    	else {
    		j=mask[i];
         j>>=(8-lognn);
      }
   	if (j>i) {
   		if (is_complex) {
      		int j2=j<1,i2=i<1;
         	for (k=0;k<nnM;k+=nn) {
      			tempr=data[j2+k];tempi=data[j2+k+1];
      			data[j2+k]=data[i2+k];
      			data[j2+k+1]=data[i2+k+1];
      			data[i2+k]=tempr;data[i2+k+1]=tempi;
            }
    		}
      	else {
         	for (k=0;k<nnM;k+=nn) {
      			tempr=data[j+k];
      			data[j+k]=data[i+k];
      			data[i+k]=tempr;
         	}
      	}
      }
  	}
}

void matrix_four1(float dataoutR[], float dataoutI[],
	 float dataR[], float dataI[],
	unsigned long N, unsigned long nn, unsigned long M, int isign)
   /*
   dataR and dataI are M by N matrices of floats in the C ordering conventionn
   (last index, N, varies fastest), so the FFT is performed on M vectors, each N long.
   nn is a power of 2 to pad to (nn>=n). The routine is "matricized" to reduce
   all the non-fourier overhead as the number of columns increases.
   Also, the routine returns the result in dataout to lower the overhead of recopying.
   isign is 1 for forward fft, -1 for reverse fft. No error checking.
   */
{
	unsigned long n,mmax,m,j,k,istep,i,nnM;
	float wtemp,wr,wpr,wpi,wi,theta,*pReal,*pImag;
	float tempr,tempi,*pf1,*pf2,*pf1a,*pf2a;
   nnM=M*nn;
   /*
   first, move the input data into the array and pad the remainder
   */
   for (i=0;i<M;i++) {
       pReal=&dataR[i*N];
       pImag=&dataI[i*N];
       pf1=dataoutR;
       pf1+=i*nn;
       pf2=dataoutI;
       pf2+=i*nn;
       for (j=0;j<N;j++) {
       	*pf1++=*pReal++;
         *pf2++=*pImag++;
       }
       for (;j<nn;j++) {
       	*pf1++=0;
         *pf2++=0;
       }
   }
   flip_array(dataoutR,nn,M,0);
   flip_array(dataoutI,nn,M,0);

	n=nn;
	mmax=1; //was 2
	while (n > mmax) {
		istep=mmax<<1;
		theta=(-isign)*(6.28318530717959/(mmax*2));
		wtemp=sin(0.5*theta);
		wpr = -2.0*wtemp*wtemp;
		wpi=sin(theta);
		wr=1.0;
		wi=0.0;
		for (m=0;m<mmax;m+=1) {  //was +=2
			for (i=m;i<n;i+=istep) {
				j=i+mmax;
      		pf1=dataoutR;
         	pf1+=j;
      		pf2=dataoutR;
         	pf2+=i;
       		pf1a=dataoutI;
         	pf1a+=j;
      		pf2a=dataoutI;
         	pf2a+=i;
         	for (k=0;k<nnM;k+=nn) { //compute on two whole columns at a time
					tempr=wr*pf1[k]-wi*pf1a[k];
					tempi=wr*pf1a[k]+wi*pf1[k];
					pf1[k]=pf2[k]-tempr;
					pf1a[k]=pf2a[k]-tempi;
					pf2[k] += tempr;
					pf2a[k] += tempi;
            }
			}
			wr=(wtemp=wr)*wpr-wi*wpi+wr;
			wi=wi*wpr+wtemp*wpi+wi;
		}
		mmax=istep;
	}
   if (isign==-1) {
   	float nn1=1/float(nn);
   	for (i=0;i<nnM;i++) {
   		dataoutR[i]*=nn1;
      	dataoutI[i]*=nn1;
   	}
   }
}

void cdecl
mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
mvar datain;
mvar dataout;
mvar premult;
mvar fftmult;
mvar postmult;
mvar nfft;
if (nlhs<1) {
	failer(-1, "should have 1 output: czt_out")
}

if (nrhs<4)
	failer(-1,"should have 4 inputs:datain,premult,fftmult,postmult")
getm(datain,prhs[0]);  //input data, dimension m rows by n columns
getm(premult,prhs[1]);
getm(fftmult,prhs[2]);
getm(postmult,prhs[3]);
getm(nfft,prhs[4]);
if (datain.cls!=mxSINGLE_CLASS)
	failer(-1,"all input data must be single precision float");
if (premult.cls!=mxSINGLE_CLASS)
	failer(-1,"all input data must be single precision float");
if (fftmult.cls!=mxSINGLE_CLASS)
	failer(-1,"all input data must be single precision float");
if (postmult.cls!=mxSINGLE_CLASS)
	failer(-1,"all input data must be single precision float");
if (nfft.cls!=mxSINGLE_CLASS)
	failer(-1,"all input data must be single precision float");
int i,j,n=datain.dim[0],m=datain.dim[1]; //n is time samples, m is space
int nn=*(float *)nfft.R;
int postfilt_len=postmult.dim[0];
int postfilt_start=n-1;
float *fftinR,*fftinI,*fftR,*fftI,*cpxmultR,*cpxmultI;
float *fftoutR,*fftoutI,*fftconvR,*fftconvI;
float *freetab[10]; //used to track alloc'd data for free up
int freeind=0;  //ditto
freetab[freeind++]=fftinR=(float *)malloc(sizeof(float)*n*m);
freetab[freeind++]=fftinI=(float *)malloc(sizeof(float)*n*m);
freetab[freeind++]=fftoutR=(float *)malloc(sizeof(float)*m*nn);
freetab[freeind++]=fftoutI=(float *)malloc(sizeof(float)*m*nn);
freetab[freeind++]=fftconvR=(float *)malloc(sizeof(float)*m*nn);
freetab[freeind++]=fftconvI=(float *)malloc(sizeof(float)*m*nn);
for (i=0;i<freeind;i++) //check for null pointers
	if (freetab[i]==NULL) {  //if any pointer null
   	for (i=0;i<freeind;i++) //free all
      	free(freetab[i]);
      failer(-1,"memory allocation failed");
   }


fftR=fftinR;
fftI=fftinI;
float *inR,*inI;
for (i=0;i<m;i++) { //for all rows (matlab columns) premultiply by conditioner
	cpxmultR=(float *)premult.R;
	cpxmultI=(float *)premult.I;
   inR=&((float *)datain.R)[i*n];
   inI=&((float *)datain.I)[i*n];
	for (j=0;j<n;j++) { //for each row, multiply complex shading by data
		float tempr,tempi;
      tempr=*inR * *cpxmultR-*inI * *cpxmultI;
      tempi=*inR++ * *cpxmultI + *inI++ * *cpxmultR;
      cpxmultR++;
      cpxmultI++;
      *fftR++ =tempr;
      *fftI++ =tempi;
   }
}

//now, data is premultiplied, go ahead and FFT it.
matrix_four1(fftoutR, fftoutI,fftinR, fftinI,n,nn,m,1); //forward fft

//now, multiply the fft result by the frequ domain convolution filter
fftR=fftoutR;
fftI=fftoutI;
for (i=0;i<m;i++) { //for all rows (matlab columns) premultiply by conditioner
	cpxmultR=(float *)fftmult.R;
	cpxmultI=(float *)fftmult.I;
	for (j=0;j<nn;j++) { //for each row, multiply complex shading by data
		float tempr,tempi;
      tempr=*fftR * *cpxmultR-*fftI * *cpxmultI;
      tempi=*fftR * *cpxmultI++ +*fftI * *cpxmultR++;
      *fftR++=tempr;
      *fftI++=tempi;
   }
}

//now do the ifft
matrix_four1(fftconvR, fftconvI,fftoutR, fftoutI,nn,nn,m,-1); //inverse fft

//now post multiply into output array
plhs[0]=mxCreateDoubleMatrix(postfilt_len,m,mxCOMPLEX); //preassign R matrix
if (plhs[0]==0) {
	for (i=0;i<freeind;i++)
		free(freetab[i]);
   failer(-1,"memory allocation failed on output");
}

getm(dataout,plhs[0]);
double *dataoutR,*dataoutI;
dataoutR=dataout.R;
dataoutI=dataout.I;
for (i=0;i<m;i++) {
	float*ffinR,*ffinI;
   ffinR=fftconvR+postfilt_start+i*nn;
   ffinI=fftconvI+postfilt_start+i*nn;
	cpxmultR=(float *)postmult.R;
	cpxmultI=(float *)postmult.I;
   for (j=0;j<postfilt_len;j++) {
		float tempr,tempi;
      tempr=*ffinR * *cpxmultR-*ffinI * *cpxmultI;
      tempi=*ffinR++ * *cpxmultI++ +*ffinI++ * *cpxmultR++;
      *dataoutR++=tempr;
      *dataoutI++=tempi;
   }
}

for (i=0;i<freeind;i++)
	free(freetab[i]);

}


