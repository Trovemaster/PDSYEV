!------------------------------------------------------------------------!
! Example of matrix diagonalization using LAPACK routine dsyev.f and the ! 
! Fortran 90 interface diasym.f90.                                       !
!------------------------------------------------------------------------!
! Input from file 'mat.dat' (matrix to be diagonalized):                 !
! line 1      : order of the symmetric matrix [M]                        !
! lines 2-n+1 : rows of the matrix                                       !
!------------------------------------------------------------------------!
! Output in file 'dia.dat':                                              !
! - eigenvalues                                                          !
! - eigenvectors (diagonalizing matrix [D])                              !
! - the original matrix [M] transformed by [D]; [1/D][M][D]              !
!------------------------------------------------------------------------!

!---------------!
 program diatest

!---------------!
 implicit none

 integer :: i,j,n,info
 real(8), allocatable :: m0(:,:),m1(:,:),m2(:,:),eig(:)
 real(8) :: elem,t1,t2

 logical :: gen_mat = .true.
 integer :: mat_len
 integer(8) :: seed(1000000)
 integer :: verbose = 1,alloc


 !open(10,file='mat.dat',status='old')
 !
 read(5,*) n
 write (6,"(' allocating m0 = ',f18.4,'gb')") real(n,8)**2*8.0d0/1024.0d0**3
 allocate (m0(n,n),eig(n),stat=alloc)

 if (alloc/=0) then
    write (6,"(' Error ',i9,' trying to allocate m0,eigen')") alloc
    stop 'm0,eig out of memory'
 endif
 !
 m0 = 0
 !
 !if (.not.gen_mat) then 
 !
 i = 0 ; j=0
 !
 do while(.true.)
   read( 5, *, iostat=info ) i, j, elem
   if ( info /= 0 ) exit   ! exit loop when reach EOF
   m0(i,j) = elem
   m0(j,i) = elem
 enddo
 !
 ! a random matrix is generated
 !
 write(6,"('Generting a random matrix of ',i8,'x',i8)") n,n
 !
 if (i==0.and.j==0) then 
   !
   do j = 1,n
      do i=j,n
        !if(i>=j)  m0(i,j) = real(rrr(i),8)/real(1099511627776.0,8)
        if(i /= j) then 
          m0(i,j) = real(rrr(j),8)/real(1099511627776.0,8)
          m0(j,i) = m0(i,j)
        endif 
        if(i==j)  m0(i,j) = m0(i,j) + real(100.0,8) * real(j,8)
      enddo
   enddo
   !
 end if
 !
 write(6,"('...done!')")
 !
 !close(10)

 !m1(:,:)=m0(:,:)

 t1 = get_real_time()

 call diasym_dsyev_i8(m0,eig,n)
 !
 !call diasym_dsyevd(m0,eig,n)

 t2 = get_real_time()
   
 !open(10,file='dia.dat',status='replace')
 !
 write(6,*)'Eigenvalues:'
 do i=1,n
    write(6,10)i,eig(i)
    10 format(I8,5x,g18.8)
 enddo
 write(6,*)
 
 if (verbose>=4) then 
  write(6,*)'Eigenvectors:'
  do i=1,n
     write(6,20)i,m0(:,i)
     20 format(i3,'   ',100f14.8)
  enddo
  write(6,*)
 endif
  

 if (verbose>=4) then 
   !
   allocate (m1(n,n),m2(n,n),stat=alloc)
   if (alloc/=0) then
      write (6,"(' Error ',i9,' trying to allocate m1 and m2')") alloc
      stop 'm1,m2 out of memory'
   endif

   m2=matmul(transpose(m1),m0)
   m0=matmul(m2,m1)
   write(6,*)'Transformed matrix (check):'
   do i=1,n
      write(6,30)m0(:,i)
      30 format(100(1x,g15.8))
   enddo
   write(6,*)
   deallocate(m1); deallocate(m2)
   !
 endif
 !
 deallocate(m0)
 deallocate(eig)
 write(6,"('N = ',i12,' Time = ',f12.1,' s')") n,t2-t1
 !

 !close(10)

 !
 contains 
  !
  integer(8) function  rrr(i)
   integer :: i
   seed(i) = mod((1103515245 * seed(i) + 12345),1099511627776_8);
   !seed(i) = mod((1103515245 * seed(i) + 12345),1099511627);
   rrr=seed(i)
   return
  end function rrr
  !
  function get_real_time() result(t)
    real(8) :: t
    !
    integer         :: count, count_rate, count_max
    real(8), save :: overflow   =  0
    integer, save   :: last_count = -1
    !
    call system_clock(count,count_rate,count_max)
    !
    ! Try to detect a rollover
    !
    if (count<last_count) then
      overflow = overflow + count_max
    end if
    last_count = count
    !
    ! Convert to seconds
    !
    t = (overflow+count)/count_rate
  end function get_real_time
  !
 end program diatest
!-------------------!

!---------------------------------------------------------!
!Calls the LAPACK diagonalization subroutine DSYEV        !
!input:  a(n,n) = real symmetric matrix to be diagonalized!
!            n  = size of a                               !
!output: a(n,n) = orthonormal eigenvectors of a           !
!        eig(n) = eigenvalues of a in ascending order     !
!---------------------------------------------------------!
 subroutine diasym_dsyev_i8(a,eig,n)
 implicit none

 integer n,l,inf,alloc
 integer(8) :: n8,l8,inf8
 double precision ::  a(n,n),eig(n)

 double precision,allocatable ::  work(:),work0(:)


 l8 =  50*n+2
 !
 allocate(work0(l8),stat=alloc)
 if (alloc/=0) then
    write (6,"(' Error ',i9,' trying to allocate work0')") alloc
    stop ' work0 are out of memory'
 endif

 l8 =-1
 n8 = n
 !
 write(6,"('Checking the size of work ...')")
 !
 call dsyev('V','U',n8,a,n8,eig,work0,l8,inf8)

 if (int(work0(1))>0) then 
   !
   l8 = int(work0(1),8)
   !
   write (6,"(' allocating work, l = ',i14,' ',f18.4,'gb')") l8,real(l8,8)*8.0d0/1024.0d0**3
   !
   allocate(work(l8),stat=alloc)
   if (alloc/=0) then
      write (6,"(' Error ',i9,' trying to allocate work')") alloc
      stop 'work out of memory'
   endif
   !
 else
   stop 'negatove size of work'
 endif
 !
 write(6,"('Start diagonalisation ...')")
 !
 call dsyev('V','U',n8,a,n8,eig,work,l8,inf8)
 !
 write(6,"('... end')")
 !
 if (inf8/=0) print*,inf8
 !
 deallocate(work)
 !
 end subroutine diasym_dsyev_i8
!---------------------!


 subroutine diasym_dsyev(a,eig,n)
 implicit none

 integer n,l,inf,alloc
 integer :: n8,l8,inf8
 double precision ::  a(n,n),eig(n),work0(n)

 double precision,allocatable ::  work(:)

 l=n*(3+n/2)
 
 l8 = l
 n8 = n
 !
 call dsyev('V','U',n8,a,n8,eig,work0,-1,inf8)

 !call dsyev('V','U',n,a,n,eig,work,l,inf)

 if (int(work0(1))>0) then 
   !
   l8 = int(work0(1))
   !
   write (6,"(' allocating work = ',f18.4,'gb')") real(l8,8)*8.0d0/1024.0d0**3
   !
   allocate(work(l8),stat=alloc)
   if (alloc/=0) then
      write (6,"(' Error ',i9,' trying to allocate work')") alloc
      stop 'work out of memory'
   endif
   !
 else
   stop 'negatove size of work'
 endif
 !
 write(6,"('Start diagonalisation ...')")
 !
 call dsyev('V','U',n8,a,n8,eig,work,l8,inf8)
 !
 write(6,"('... end')")
 !
 if (inf8/=0) print*,inf8
 !
 deallocate(work)
 !
 end subroutine diasym_dsyev
!---------------------!

 subroutine diasym_dsyevd(a,eig,n)
 implicit none

 integer n,l,inf,alloc
 integer :: n8,l8,inf8,k8
 double precision ::  a(n,n),eig(n),work0(n)
 integer :: iwork0(n)
 integer,allocatable :: iwork(:)
 double precision,allocatable ::  work(:)

 
 l8 = -1
 k8 = -1
 n8 = n
 !
 call dsyevd('V','U',n8,a,n8,eig,work0,l8,iwork0,k8,inf8)
 !
 if (inf8/=0) then
   write(6,"('dsyevd error ',i8)") inf8
   stop 'dsyevd error'
 endif
 !
 if (int(work0(1),8)>0.and.int(iwork0(1),8)>0) then 
   !
   l8 = int(work0(1))
   write (6,"(' allocating work = ',f18.4,'gb')") real(l8,8)*8.0d0/1024.0d0**3
   !
   if (alloc/=0) then
      write (6,"(' Error ',i9,' trying to allocate work')") alloc
      stop 'work out of memory'
   endif
   !
   k8 = int(iwork0(1))
   write (6,"(' allocating iwork = ',f18.4,'gb')") real(k8,8)*4.0d0/1024.0d0**3
   !
   allocate(iwork(l8),stat=alloc)
   if (alloc/=0) then
      write (6,"(' Error ',i9,' trying to allocate iwork')") alloc
      stop 'iwork out of memory'
   endif
   !
 else
   write(6,"('work(1) and iworl(1) are ',2i8)"), int(work0(1),8),int(iwork0(1),8)
   stop 'illegal sizes of work or iwork'
 endif
 !
 write(6,"('Start diagonalisation using dsyevd...')")
 !
 call dsyevd('V','U',n8,a,n8,eig,work,l8,iwork,k8,inf8)
 !
 if (inf8/=0) then
   write(6,"('dsyevd error ',i8)") inf8
   stop 'dsyevd error'
 endif
 !
 write(6,"('... end')")
 !
 if (inf8/=0) print*,inf8
 !
 deallocate(work)
 !
 end subroutine diasym_dsyevd
!---------------------!


 subroutine diasym_dsyevd_i8(a,eig,n)
 implicit none

 integer n,l,inf,alloc
 integer(8) :: n8,l8,inf8,k8
 double precision ::  a(n,n),eig(n),work0(n)
 integer(8) :: iwork0(n)
 integer(8),allocatable :: iwork(:)
 double precision,allocatable ::  work(:)

 l=n*(3+n/2)
 
 l8 = -1
 k8 = -1
 n8 = n
 !
 call dsyevd('V','U',n8,a,n8,eig,work0,l8,iwork0,k8,inf8)
 !
 if (inf8/=0) then
   write(6,"('dsyevd error ',i8)") inf8
   stop 'dsyevd error'
 endif
 !
 if (int(work0(1),8)>0.and.int(iwork0(1),8)>0) then 
   !
   l8 = int(work0(1),8)
   write (6,"(' allocating work = ',f18.4,'gb')") real(l8,8)*8.0d0/1024.0d0**3
   !
   if (alloc/=0) then
      write (6,"(' Error ',i9,' trying to allocate work')") alloc
      stop 'work out of memory'
   endif
   !
   k8 = int(iwork0(1),8)
   write (6,"(' allocating iwork = ',f18.4,'gb')") real(k8,8)*4.0d0/1024.0d0**3
   !
   allocate(iwork(l8),stat=alloc)
   if (alloc/=0) then
      write (6,"(' Error ',i9,' trying to allocate iwork')") alloc
      stop 'iwork out of memory'
   endif
   !
 else
   write(6,"('work(1) and iworl(1) are ',2i8)"), int(work0(1),8),int(iwork0(1),8)
   stop 'illegal sizes of work or iwork'
 endif
 !
 write(6,"('Start diagonalisation using dsyevd...')")
 !
 call dsyevd('V','U',n8,a,n8,eig,work,l8,iwork,k8,inf8)
 !
 if (inf8/=0) then
   write(6,"('dsyevd error ',i8)") inf8
   stop 'dsyevd error'
 endif
 !
 write(6,"('... end')")
 !
 if (inf8/=0) print*,inf8
 !
 deallocate(work)
 !
 end subroutine diasym_dsyevd_i8
!---------------------!



 subroutine diasym_dsyevd_v2(a,eig,n)
 implicit none

 integer n,l,inf,alloc
 integer(8) :: n8,l8,inf8,k8
 double precision ::  a(n,n),eig(n)
 double precision,allocatable ::  work(:),work0(:)
 integer(8),allocatable :: iwork(:),iwork0(:)

 l=n*(3+n/2)
 
 l8 =  1 + 6*n + 2*n**2
 k8 = 10+5*n
 n8 = n
 !
 allocate(work0(l8),iwork0(k8),stat=alloc)
 if (alloc/=0) then
    write (6,"(' Error ',i9,' trying to allocate iwork')") alloc
    stop ' work0 and iwork0 are out of memory'
 endif

 !
 call dsyevd('V','U',n8,a,n8,eig,work0,-1_8,iwork0,-1_8,inf8)
 !
 if (inf8/=0) then
   write(6,"('dsyevd error ',i8)") inf8
   stop 'dsyevd error'
 endif
 !
 if (int(work0(1),8)>0.and.int(iwork0(1),8)>0) then 
   !
   l8 = int(work0(1),8)
   write (6,"(' allocating work = ',f18.4,'gb')") real(l8,8)*8.0d0/1024.0d0**3
   !
   if (alloc/=0) then
      write (6,"(' Error ',i9,' trying to allocate work')") alloc
      stop 'work out of memory'
   endif
   !
   k8 = int(iwork0(1),8)
   write (6,"(' allocating iwork = ',f18.4,'gb')") real(k8,8)*4.0d0/1024.0d0**3
   !
   allocate(iwork(l8),stat=alloc)
   if (alloc/=0) then
      write (6,"(' Error ',i9,' trying to allocate iwork')") alloc
      stop 'iwork out of memory'
   endif
   !
   deallocate(iwork0,work0)
   !
 else
   write(6,"('work(1) and iworl(1) are ',f16.8,1x,i8)"), work0(1),iwork0(1)
   stop 'illegal sizes of work or iwork'
 endif
 !
 write(6,"('Start diagonalisation using dsyevd...')")
 !
 call dsyevd('V','U',n8,a,n8,eig,work,l8,iwork,k8,inf8)
 !
 if (inf8/=0) then
   write(6,"('dsyevd error ',i8)") inf8
   stop 'dsyevd error'
 endif
 !
 write(6,"('... end')")
 !
 if (inf8/=0) print*,inf8
 !
 deallocate(work)
 !
 end subroutine diasym_dsyevd_v2
!---------------------!
