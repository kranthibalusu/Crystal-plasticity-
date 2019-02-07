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
!> @author Martin Diehl, Max-Planck-Institut für Eisenforschung GmbH
!> @brief all DAMASK files without solver
!> @details List of files needed by MSC.Marc, Abaqus/Explicit, and Abaqus/Standard
!--------------------------------------------------------------------------------------------------
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\IO.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\numerics.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\debug.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\math.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\FEsolving.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\mesh.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\material.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\lattice.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\source_thermal_dissipation.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\source_thermal_externalheat.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\source_damage_isoBrittle.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\source_damage_isoDuctile.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\source_damage_anisoBrittle.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\source_damage_anisoDuctile.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\source_vacancy_phenoplasticity.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\source_vacancy_irradiation.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\source_vacancy_thermalfluc.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\kinematics_cleavage_opening.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\kinematics_slipplane_opening.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\kinematics_thermal_expansion.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\kinematics_vacancy_strain.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\kinematics_hydrogen_strain.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\plastic_none.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\plastic_isotropic.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\plastic_phenopowerlaw.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\plastic_phenoplus.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\plastic_titanmod.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\plastic_dislotwin.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\plastic_disloUCLA.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\plastic_nonlocal.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\constitutive.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\crystallite.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\homogenization_none.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\homogenization_isostrain.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\homogenization_RGC.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\thermal_isothermal.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\thermal_adiabatic.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\thermal_conduction.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\damage_none.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\damage_local.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\damage_nonlocal.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\vacancyflux_isoconc.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\vacancyflux_isochempot.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\vacancyflux_cahnhilliard.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\porosity_none.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\porosity_phasefield.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\hydrogenflux_isoconc.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\hydrogenflux_cahnhilliard.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\homogenization.f90"
#include "C:\Users\astl2\Desktop\CPFEMDAMASK\DAMASK\code\CPFEM.f90"
