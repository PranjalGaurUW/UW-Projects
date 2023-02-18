﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DemoWebAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace DemoWebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : Controller
    {
        private readonly ShopContext _context;
        public ProductsController(ShopContext context)
        {
            _context = context;
            _context.Database.EnsureCreated();//Run seeding
        }
        [HttpGet]
        public async Task<IActionResult> GetProducts([FromQuery] ProductQueryParameters queryParameters)
        {
            IQueryable<Product> products = _context.Products;
            //pagination; skip (page-1)pages*size and return data from page=Page and size = Size
            products = products
                        .Skip(queryParameters.Size * (queryParameters.Page - 1))
                        .Take(queryParameters.Size);
            //Filter using Price
            if(queryParameters.MinPrice!=null)
            {
                products = products
                           .Where(x => x.Price >= queryParameters.MinPrice);
            }
            if(queryParameters.MaxPrice!=null)
            {
                products = products
                           .Where(x => x.Price <= queryParameters.MaxPrice);
            }

            //Search products using name
            if(!String.IsNullOrEmpty(queryParameters.Name))
            {
                products = products
                           .Where(p => p.Name.ToLower().Contains(queryParameters.Name.ToLower()));
            }

            return Ok(await products.ToListAsync());
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetProduct(int id)
        {
            var product = await _context.Products.FindAsync(id);//finds an entity with the given primary key value
            if(product==null)
                return NotFound();
            else return Ok(product);
        }

        [HttpPost]
        public async Task<ActionResult<Product>> AddProduct(Product product)
        {
            _context.Products.Add(product);
            await _context.SaveChangesAsync();
            return CreatedAtAction(
                "GetProduct",
                new { id = product.Id },
                product
                );
        }

        [HttpPut ("{id}")]
        public async Task<IActionResult> UpdateProduct(int id, Product product)
        {
            if (id != product.Id)
                return BadRequest();
            _context.Entry(product).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch(DbUpdateConcurrencyException)
            {
                if (!_context.Products.Any(x => x.Id == id))
                    return NotFound();
                else
                    throw;
            }
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult<Product>> DeleteProduct(int id)
        {
            var item = await _context.Products.FindAsync(id);
            if (item == null) return NotFound();

            _context.Products.Remove(item);
            await _context.SaveChangesAsync();
            return item;
        }
    }
}
