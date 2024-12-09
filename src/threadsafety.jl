const _qcdnum_lock = ReentrantLock()

"""
    qcdnum_lock()::AbstractLock

Get the global lock for QCDNUM operations.

The QCDNUM Fortran package itself is not thread-safe, so QCDNUM.jl uses
a global lock do guard against parallel calls to the Fortran library.
"""
@inline qcdnum_lock() = _qcdnum_lock
export qcdnum_lock


"""
    QCDNUM.@qlccall expr

Equivalent to `@lock qcdnum_lock() @ccall ...`.
"""
macro qlccall(expr)
    #    global g_expr = expr
    # Can't use esc(expr), doesn't work with typeassert AST, so:
    esc_expr = :($(_ccall_esc_outer(expr)))
    #    global g_esc_expr = esc_expr
    #    @info "DEBUG" expr esc_expr
    #new_expr = :(@ccall $esc_expr)
    #    @info "DEBUG" new_expr
    #    global g_new_expr = new_expr

    new_expr = quote
        lck = qcdnum_lock()
        try
            lock(lck)
            @ccall $esc_expr
        finally
            unlock(lck)
        end
    end
    return new_expr
end

function _ccall_esc_outer(expr::Expr)
    if expr.head == :(::) # typeassert
        call_expr, ret_type = expr.args
        return Expr(:(::), _ccall_esc_call(call_expr), esc(ret_type))
    else
        throw(ArgumentError("@qlccall call expression must have a return type annotation."))
    end
end

function _ccall_esc_call(expr::Expr)
    if expr.head == :(call) # typeassert
        func = expr.args[begin]
        args = expr.args[begin+1:end]
        return Expr(:call, func, map(_ccall_esc_arg, args)...)
    else
        throw(ArgumentError("@qlccall has to take a function call."))
    end
end

function _ccall_esc_arg(expr::Expr)
    if expr.head == :(::) # typeassert
        arg_expr, arg_type = expr.args
        return Expr(:(::), esc(arg_expr), esc(arg_type))
    else
        throw(ArgumentError("@qlccall call arguments must have type annotations."))
    end
end
