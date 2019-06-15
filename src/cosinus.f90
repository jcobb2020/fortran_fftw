program main
    use, intrinsic :: iso_c_binding
    implicit none
    include "fftw3.f03"

    integer, parameter :: n = 1024
    real(c_double), allocatable :: in_data(:)
    complex(c_double_complex), allocatable :: out_data(:)
    type(c_ptr) :: planf, planb
    integer(kind = 4) :: i
    real (kind = 8) :: t
    real (kind = 8) :: step = 1.0/(n-1.0)
    real :: random, random2
    complex(c_double_complex) :: zero = (0,0)

    allocate(in_data(n))
    allocate(out_data(n/2 + 1))

    open(1, file = "res/original_signal_2")
    open(2, file = "res/transformed_signal_2")
    open(3, file = "res/result_signal_2")
    write(1, *) "col1, col2"
    write(2, *) "col1, col2"
    write(3, *) "col1, col2"

    call random_seed()
    do i=1, n
        call RANDOM_NUMBER(random)
        call RANDOM_NUMBER(random2)
        in_data(i) = cos(2 * 3.1416 * t) + random/7 - random2/7
        write(1, *) t, ", ", in_data(i)
        t = t + step
    end do

    planf = fftw_plan_dft_r2c_1d(size(in_data), in_data, out_data, FFTW_ESTIMATE+FFTW_UNALIGNED)
    call fftw_execute_dft_r2c(planf, in_data, out_data)

    do i=1, n/2+1
        if (abs(out_data(i)) < 50) then
            out_data(i) = zero
        end if
    end do

    t = 0
    do i=1, n/2+1
        write(2, *) i, ", ", abs(out_data(i))
    end do

    planb = fftw_plan_dft_c2r_1d(size(in_data), out_data, in_data, FFTW_ESTIMATE+FFTW_UNALIGNED)

    call fftw_execute_dft_c2r(planb, out_data, in_data)

    t = 0
    do i=1, n
        write(3, *) t, ", ", in_data(i)/n
        t = t + step
    end do



end program main

