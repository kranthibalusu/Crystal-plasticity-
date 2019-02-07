! Copyright 2011-16 Max-Planck-Institut für Eisenforschung GmbH
! 
! This program is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
! 
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
! GNU General Public License for more details.
! 
! You should have received a copy of the GNU General Public License
! along with this program. If not, see <http://www.gnu.org/licenses/>.
!--------------------------------------------------------------------------------------------------
!> @author   Martin Diehl, Max-Planck-Institut für Eisenforschung GmbH
!> @brief    provides wrappers to C routines
!--------------------------------------------------------------------------------------------------
module system_routines
 
 implicit none
 private
 
 public :: &
   isDirectory, &
   getCWD

interface

 function  isDirectory_C(path) BIND(C)
   use, intrinsic :: ISO_C_Binding, only: &
     C_INT, &
     C_CHAR
   integer(C_INT) :: isDirectory_C
   character(kind=C_CHAR), dimension(1024), intent(in) :: path                                      ! C string is an array
  end function isDirectory_C

 subroutine getCurrentWorkDir_C(str, stat) bind(C)
   use, intrinsic :: ISO_C_Binding, only: &
     C_INT, &
     C_CHAR
   character(kind=C_CHAR), dimension(1024), intent(out)  :: str                                     ! C string is an array
   integer(C_INT),intent(out)         :: stat
  end subroutine getCurrentWorkDir_C

end interface


contains

!--------------------------------------------------------------------------------------------------
!> @brief figures out if a given path is a directory (and not an ordinary file)
!--------------------------------------------------------------------------------------------------
logical function isDirectory(path)
  use, intrinsic :: ISO_C_Binding, only: &
    C_INT, &
    C_CHAR, &
    C_NULL_CHAR

  implicit none
  character(len=*), intent(in) :: path
  character(kind=C_CHAR), dimension(1024) :: strFixedLength
  integer :: i 

  strFixedLength = repeat(C_NULL_CHAR,len(strFixedLength))
  do i=1,len(path)                                                                                  ! copy array components
    strFixedLength(i)=path(i:i)
  enddo
  isDirectory=merge(.True.,.False.,isDirectory_C(strFixedLength) /= 0_C_INT)

end function isDirectory


!--------------------------------------------------------------------------------------------------
!> @brief gets the current working directory
!--------------------------------------------------------------------------------------------------
logical function getCWD(str)
  use, intrinsic :: ISO_C_Binding, only: &
    C_INT, &
    C_CHAR, &
    C_NULL_CHAR

  implicit none
  character(len=*), intent(out) :: str
  character(kind=C_CHAR), dimension(1024) :: strFixedLength                                         ! C string is an array
  integer(C_INT) :: stat
  integer :: i

  str = repeat('',len(str))
  call getCurrentWorkDir_C(strFixedLength,stat)
  do i=1,1024                                                                                       ! copy array components until Null string is found
    if (strFixedLength(i) /= C_NULL_CHAR) then
      str(i:i)=strFixedLength(i)
    else
      exit
    endif
  enddo
  getCWD=merge(.True.,.False.,stat /= 0_C_INT)

end function getCWD

end module system_routines

