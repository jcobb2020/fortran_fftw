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


    allocate(in_data(n))
    allocate(out_data(n/2 + 1))



    open(1, file = "res/original_signal_1")
    open(2, file = "res/transformed_signal_1")
    write(1, *) "col1, col2"
    write(2, *) "col1, col2"

    do i=1, n
        in_data(i) = sin(2 * 3.1416 * t * 200) + 2 * sin(2 * 3.1416 * t * 400)
        write(1, *) t, ", ", in_data(i)
        t = t + step
    end do

    !write(*,*) step

    planf = fftw_plan_dft_r2c_1d(size(in_data), in_data, out_data, FFTW_ESTIMATE+FFTW_UNALIGNED)
    call fftw_execute_dft_r2c(planf, in_data, out_data)

    do i=1, n/2+1
        write(2, *) i, ", ", abs(out_data(i))
        t = t + step
    end do

    call fftw_destroy_plan(planf)

end program main